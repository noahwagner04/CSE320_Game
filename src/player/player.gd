extends CharacterBody2D

signal toggle_inventory()

var sync_pos := Vector2.ZERO
var mult_sync: MultiplayerSynchronizer

@onready var health_bar: ProgressBar = %HealthBar
@onready var health_container: HealthContainer = %HealthContainer
@onready var motion_controller: MotionController = %MotionController

@export var inventory_data: InventoryData

@onready var player_stats = $PlayerStats

func _ready():
	set_health()
	if multiplayer.get_unique_id() == str(name).to_int():
		$Camera2D.make_current()

func set_health():
	health_container.max_health = player_stats.health
	health_container._health = player_stats.health
	health_bar.max_value = health_container.max_health


func _process(_delta):
	# only move the player if we are the client controlling them
	if mult_sync.get_multiplayer_authority() == multiplayer.get_unique_id():
		sync_pos = global_position
		move(_delta)
		# check inventory toggle
		if Input.is_action_just_pressed("toggle_inventory"):
			toggle_inventory.emit()
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
	health_bar.value = health_container.get_health()
	if _amount < 0:
		%HurtSound.play(0.75)


func _on_health_container_health_depleted():
	$DeathSound.play()
	await get_tree().create_timer(1.3).timeout
	queue_free()


func _on_tree_entered():
	mult_sync = %MultiplayerSynchronizer
	mult_sync.set_multiplayer_authority(str(name).to_int())
	
