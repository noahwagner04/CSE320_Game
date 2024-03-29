extends CharacterBody2D

var home := Node2D.new()
var _target: Node2D

@onready var motion_controller: MotionController = %MotionController
@onready var col_detector: Area2D = %ColliderDetector
@onready var xp_dropper = $xp_dropper


func _ready():
	home.global_position = global_position
	motion_controller.max_speed += (randf() * 2 - 1) * 10


func _physics_process(_delta):
	_target = col_detector.get_closest_collider()
	_target = home if _target == null else _target 
	
	motion_controller.move(global_position.direction_to(_target.global_position), _delta)
	velocity = motion_controller.velocity
	move_and_slide()


func _on_health_container_health_depleted():
	xp_dropper.drop_xp()
	queue_free()
