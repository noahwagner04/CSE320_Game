extends CharacterBody2D

@export var stop_range: float = 100
@onready var xp_dropper = $xp_dropper

var _target: Node2D
var sync_pos: Vector2
var mult_sync: MultiplayerSynchronizer
var first_frame := true

@onready var motion_controller: MotionController = %MotionController
@onready var col_detector: Area2D = %ColliderDetector
@onready var proj_spawner: Node2D = %ProjectileSpawner


func _ready():
	if not multiplayer.is_server():
		set_physics_process(false)
	$AttackTimer.start()
	motion_controller.max_speed += (randf() * 2 - 1) * 10


func _physics_process(delta):
	
	if mult_sync.get_multiplayer_authority() == multiplayer.get_unique_id():
		
		_target = col_detector.get_closest_collider()
		if _target == null:
			motion_controller.apply_friction(delta)
			return
	
		var new_target = _target.global_position.direction_to(global_position)
		new_target *= stop_range
		new_target += _target.global_position
	
		motion_controller.move(global_position.direction_to(new_target), delta)
		velocity = motion_controller.velocity
		move_and_slide()
		
		sync_pos = global_position
		
		if first_frame:
			set_spawn_location.rpc(global_position)
			first_frame = false
	
	else:
		global_position = global_position.lerp(sync_pos, 0.4)


func _on_health_container_health_depleted():
	xp_dropper.drop_xp()
	%DeathAnimator.animate()
	queue_free()


func _on_hurt_box_hurt(hit_box):
	$bughurt.play(3.3)
	$HitEffectPlayer.play("hit")

func _on_attack_timer_timeout():
	if _target:
		proj_spawner.spawn_projectile(global_position.direction_to(_target.global_position))

		$BugSpit.play()

func _on_tree_entered():
	mult_sync = %DragonflySync
	mult_sync.set_multiplayer_authority(1)
	
@rpc("any_peer")
func set_spawn_location(spawn_location):
	global_position = spawn_location
	sync_pos = global_position
	set_physics_process(true)

