extends Node2D

const PickUp = preload("res://src/inventory/pick_up.tscn")

const TEST_INV = preload("res://src/test_inv.tres")
const TEST_WEAPON_INV = preload("res://src/test_weapon_inv.tres")
var current_player: CharacterBody2D
@onready var inventory_interface = $UI/InventoryInterface
@onready var hot_bar_inventory = $UI/HotBarInventory


func _ready():
	GameManager.new_player_created.connect(on_player_created)

# For future reference, the call in _ready doesn't need an argument;
# GameManager's emit passes the argument automatically.
func on_player_created(new_player: CharacterBody2D):
	current_player = new_player
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
