extends CharacterBody2D

signal toggle_inventory()

var sync_pos := Vector2.ZERO
var mult_sync: MultiplayerSynchronizer

@onready var health_bar: ProgressBar = %HealthBar
@onready var health_container: HealthContainer = %HealthContainer
@onready var motion_controller: MotionController = %MotionController

@export var inventory_data: InventoryData
@export var weapon_inventory_data: InventoryDataWeapon
var equipped_weapon: Weapon
var starting_item_data_weapon: ItemDataWeapon
const EQUIP_INVENTORY_WEAPON = 0

@onready var player_stats = $PlayerStats

func _ready():
	set_health()
	PlayerManager.player = self
	weapon_inventory_data.weapon_changed.connect(change_weapon)
	weapon_inventory_data.weapon_removed.connect(removed_weapon)
	# exported inventories: would likely start based on class selection
	# based on class, select starting weapon
	# for now, using a default starting_weapon resource of dagger
	starting_item_data_weapon = preload("res://src/items/dagger1.tres")
	# again, this is based off of the test_weapon_inventory.tres having
		# a dagger. 
	change_weapon(starting_item_data_weapon)
	
	
	if multiplayer.get_unique_id() == str(name).to_int():
		$Camera2D.make_current()

func set_health():
	health_container.max_health = player_stats.health
	health_container.health = player_stats.health
	health_bar.max_value = health_container.max_health
	health_bar.value = health_container.health


func _process(_delta):
	# only move the player if we are the client controlling them
	if mult_sync.get_multiplayer_authority() == multiplayer.get_unique_id():
		sync_pos = global_position
		move(_delta)
		# check inventory toggle
		if Input.is_action_just_pressed("toggle_inventory"):
			toggle_inventory.emit()
		if Input.is_action_just_pressed("interact"):
			interact()
		if Input.is_action_pressed("basic_attack") and equipped_weapon:
			equipped_weapon.basic_attack()
			#%SwingSound.play(0.2)
		if Input.is_action_pressed("item_special") and equipped_weapon:
			equipped_weapon.item_special()
	else:
		global_position = global_position.lerp(sync_pos, 0.4)


func move(_delta):
	
	# get acceleration direction
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# apply friction if no input is pressed
	if direction.length() == 0:
		motion_controller.stop_desired_motion()
	
	# apply acceleration and limit velocity
	motion_controller.acc_dir = direction
	motion_controller.update(_delta)
	
	# move the player
	velocity = motion_controller.get_velocity()
	move_and_slide()
	


func _on_health_container_health_changed(_amount):
	health_bar.value = health_container.health
	if _amount < 0:
		%HurtSound.play(0.75)


func _on_health_container_health_depleted():
	$DeathSound.play()
	await get_tree().create_timer(1.3).timeout
	queue_free()


func _on_tree_entered():
	mult_sync = %MultiplayerSynchronizer
	mult_sync.set_multiplayer_authority(str(name).to_int())
	
func interact():
	print("interact")
	
func get_drop_position() -> Vector2:
	var current_position = global_position
	current_position += Vector2(40, -40)
	return current_position
	
func heal(amount: int):
	health_container.heal(amount)

func change_weapon(weapon_item_data: ItemDataWeapon):
	if equipped_weapon:
		equipped_weapon.queue_free()
	equipped_weapon = weapon_item_data.weapon.instantiate()
	equipped_weapon.weapon_rarity = weapon_item_data.weapon_rarity
	add_child(equipped_weapon)
	print("equipped weapon has been changed to: %s" % weapon_item_data.name)

func removed_weapon():
	equipped_weapon = null
