extends CharacterBody2D

@export var speed = 300
@export var acceleration = 3000
@export var friction = 3000

@onready var health_bar: ProgressBar = %HealthBar
@onready var health_container: HealthContainer = %HealthContainer

func _ready():
	health_bar.max_value = health_container.max_health

func move(_delta):
	# get acceleration direction
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# apply friction if no input is pressed
	if direction.length() == 0:
		if velocity.length() > friction * _delta:
			velocity -= velocity.normalized() * friction * _delta
		else:
			velocity = Vector2.ZERO
	
	# apply acceleration and limit velocity
	velocity += direction * acceleration * _delta
	velocity = velocity.limit_length(speed)
	
	# move the player
	move_and_slide()
	
func _process(_delta):
	move(_delta)

func _on_health_container_health_changed(_amount):
	health_bar.value = health_container.get_health()

func _on_health_container_health_depleted():
	queue_free()
