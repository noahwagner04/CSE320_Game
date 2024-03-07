class_name MotionController 
extends Node

@export var friction: float = 0
@export var max_speed: float = INF
@export var acc_mag: float = 1

var acc_dir := Vector2.ZERO:
	set(direction):
		acc_dir = direction.normalized()
var _desired_velocity := Vector2.ZERO:
	set(velocity):
		_desired_velocity = velocity.limit_length(max_speed)
var _external_velocity := Vector2.ZERO


func get_velocity() -> Vector2:
	return _desired_velocity + _external_velocity


func stop_desired_motion():
	if _desired_velocity == Vector2.ZERO:
		return
	_external_velocity += _desired_velocity
	_desired_velocity = Vector2.ZERO
	acc_dir = Vector2.ZERO


# possibly add a decelerate counter part. It behaves similarly to friction, but
# on _desired_veloicty instead
func accelerate(delta_time: float):
	_desired_velocity += acc_dir * acc_mag * delta_time


func apply_acceleration(external_acc: Vector2, delta_time: float):
	_external_velocity += external_acc * delta_time


func apply_impulse(delta_velocity: Vector2):
	_external_velocity += delta_velocity

func apply_friction(delta_time: float):
	apply_acceleration(-_external_velocity.normalized() * friction, delta_time)
	if _external_velocity.length() < friction * delta_time:
		_external_velocity = Vector2.ZERO


func update(delta_time: float):
	accelerate(delta_time)
	apply_friction(delta_time)
