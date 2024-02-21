extends CharacterBody2D

signal toggle_inventory()

@onready var health_bar: ProgressBar = %HealthBar
@onready var health_container: HealthContainer = %HealthContainer
@onready var motion_controller: MotionController = %MotionController

@export var inventory_data: InventoryData



func _ready():
	health_bar.max_value = health_container.max_health


func _process(_delta):
	move(_delta)
	# check inventory toggle
	if Input.is_action_just_pressed("toggle_inventory"):
		toggle_inventory.emit()
	
	
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
	queue_free()
