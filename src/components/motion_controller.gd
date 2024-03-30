class_name MotionController 
extends Node

@export var max_speed: float = INF
@export var move_force_mag: float = 1
@export var mass: float = 1
@export var friction_mag: float = 0


var velocity := Vector2.ZERO


# possibly add a decelerate counter part. It behaves similarly to friction, but
# on _desired_veloicty instead
func move(force_dir: Vector2, delta_time: float):
	apply_force(force_dir * move_force_mag, delta_time)
	velocity = velocity.limit_length(max_speed)


func apply_force(force: Vector2, delta_time: float):
	velocity += force * delta_time / mass


func apply_impulse(delta_momentum: Vector2):
	velocity += delta_momentum / mass


func apply_friction(delta_time: float):
	apply_force(-velocity.normalized() * friction_mag, delta_time)
	if velocity.length() < friction_mag * delta_time:
		velocity = Vector2.ZERO
