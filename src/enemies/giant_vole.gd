extends CharacterBody2D

@export var agro_dist: float = 300

var home := Node2D.new()

var _rand_target_mod := Vector2((randf() * 2 - 1) * 10, (randf() * 2 - 1) * 10)
var _target: Node2D

@onready var collider: CollisionShape2D = %HitBoxShape
@onready var motion_controller: MotionController = %MotionController
@onready var col_detector: Area2D = %ColliderDetector


func _ready():
	home.global_position = global_position
	motion_controller.max_speed += (randf() * 2 - 1) * 10


func _physics_process(_delta):
	_target = col_detector.get_closest_collider()
	_target = home if _target == null else _target 
	
	var new_target = _target.global_position + _rand_target_mod
	
	motion_controller.acc_dir = global_position.direction_to(new_target)
	motion_controller.update(_delta)
	velocity = motion_controller.get_velocity()
	move_and_slide()


func _on_health_container_health_depleted():
	queue_free()


func _on_hurt_box_hurt(hit_box):
	motion_controller.apply_impulse((global_position - hit_box.global_position).normalized() * hit_box.knockback)
