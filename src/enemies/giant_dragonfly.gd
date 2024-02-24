extends CharacterBody2D

@export var stop_range: float = 100

var _target: Node2D

@onready var motion_controller: MotionController = %MotionController
@onready var col_detector: Area2D = %ColliderDetector
@onready var proj_spawner: Node2D = %ProjectileSpawner

func _ready():
	$AttackTimer.start()
	motion_controller.max_speed += (randf() * 2 - 1) * 10

func _process(delta):
	_target = col_detector.get_closest_collider()
	if _target == null:
		motion_controller.stop_desired_motion()
		return
	
	var new_target = _target.global_position.direction_to(global_position)
	new_target *= stop_range
	new_target += _target.global_position
	
	motion_controller.acc_dir = global_position.direction_to(new_target)
	motion_controller.update(delta)
	velocity = motion_controller.get_velocity()
	move_and_slide()


func _on_health_container_health_depleted():
	$bugsplat.play()
	await get_tree().create_timer(.27).timeout
	queue_free()


	
func _on_hurt_box_hurt(hit_box):
	motion_controller.apply_impulse((global_position - hit_box.global_position).normalized() * hit_box.knockback)
	$bughurt.play(3.3)



func _on_attack_timer_timeout():
	if _target:
		proj_spawner.spawn_projectile(global_position.direction_to(_target.global_position))
