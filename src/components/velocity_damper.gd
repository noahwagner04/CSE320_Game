class_name VelocityDamper extends Node

@export var damping: float = 0
var _velocity: Vector2 = Vector2.ZERO

func get_velocity() -> Vector2:
	return _velocity

func set_velocity(new_velocity: Vector2):
	_velocity = new_velocity
	set_physics_process(true)

func change_velocity(new_velocity: Vector2):
	_velocity += new_velocity
	set_physics_process(true)

func _physics_process(delta):
	if _velocity.length() <= damping * delta:
		_velocity = Vector2.ZERO
		set_physics_process(false)
	_velocity -= _velocity.normalized() * damping * delta
