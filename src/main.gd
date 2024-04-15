extends Node2D

const PickUp = preload("res://src/inventory/pick_up.tscn")
const TEST_INV = preload("res://src/test_inv.tres")
const TEST_WEAPON_INV = preload("res://src/test_weapon_inv.tres")
var current_player: CharacterBody2D
@onready var inventory_interface = $UI/InventoryInterface
@onready var hot_bar_inventory = $UI/HotBarInventory


func _ready():
	#GameManager.new_player_created.connect(on_player_created)
	
	print("level ready")
	if not multiplayer.is_server():
		return
	
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)

	# Spawn already connected players.
	for id in multiplayer.get_peers():
		add_player(id)

	# Spawn the local player unless this is a dedicated server export.
	if not OS.has_feature("dedicated_server"):
		add_player(1)


# For future reference, the call in _ready doesn't need an argument;
# GameManager's emit passes the argument automatically.
@rpc("any_peer", "call_local")
func on_player_created(id: int):
	current_player = get_node("/root/Startup/Level/Main/Players/" + str(id))
	#current_player.inventory_data = TEST_INV
	#current_player.weapon_inventory_data = TEST_WEAPON_INV
	current_player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(current_player.inventory_data)
	inventory_interface.set_weapon_inventory_data(current_player.weapon_inventory_data)
	hot_bar_inventory.set_inventory_data(current_player.inventory_data)


func toggle_inventory_interface():
	inventory_interface.visible = not inventory_interface.visible
	hot_bar_inventory.visible = not hot_bar_inventory.visible


func _on_inventory_interface_drop_slot_data(slot_data):
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = current_player.get_drop_position()
	add_child(pick_up)	

# temparay fix on inventory, but host will only have it
func add_player(id: int):
	print("add player: " + str(id))
	var character = preload("res://src/player/player.tscn").instantiate()
	character.global_position = Vector2.ZERO
	character.name = str(id)
	$Players.add_child(character, true)
	on_player_created.rpc_id(id,id)


func del_player(id: int):
	if not $Players.has_node(str(id)):
		return
	$Players.get_node(str(id)).queue_free()


func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)
