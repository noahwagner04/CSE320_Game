extends CharacterBody2D

@export var agro_dist: float = 300

var _target: Node2D

@onready var health_checker: HealthContainer = %HealthContainer
@onready var motion_controller: MotionController = %MotionController
@onready var player: Node = get_tree().get_first_node_in_group("player")
@onready var second_phase: bool = false
@onready var start_position: Vector2 = global_position

func _physics_process(_delta):
	var player_dist: float
	
	if player != null:
		player_dist = global_position.distance_to(player.global_position)
		if player_dist <= agro_dist:
			_target = player
			if (agro_dist < 450):
				agro_dist = 450
		else:
			_target = null
	else:
		if (player == null):
			player = get_tree().get_first_node_in_group("player")
		return
	
	if (_target != null):
		motion_controller.acc_dir = global_position.direction_to(_target.global_position)
	else:
		motion_controller.acc_dir = global_position.direction_to(start_position)
	
	motion_controller.update(_delta)
	velocity = motion_controller.get_velocity()
	move_and_slide()
	
func summon_voles(ring_num):
	var angle: float
	var giant_vole_scene: PackedScene = preload("res://src/enemies/giant_vole.tscn")
	var i: int = 1
	var vole_guard: Node
	
	ring_num = 3
	
	while i <= ring_num:
		for j in range(i * 8):
			vole_guard = giant_vole_scene.instantiate()
			
			angle = j * 0.25 / i * PI
			vole_guard.global_position = player.global_position + 64 * (1 + i) * Vector2(cos(angle), sin(angle))
			
			call_deferred("add_sibling", vole_guard, false)
			
		i += 1
		
	#if (large_ring == 1):
		#for i in 16:
			#vole_guard = giant_vole_scene.instantiate()
			
			#angle = i * 0.125 * PI
			#vole_guard.global_position = player.global_position + 192 * Vector2(cos(angle), sin(angle))
			
			#call_deferred("add_sibling", vole_guard, false)
		
func _on_health_container_health_depleted():
	queue_free()

func _on_hurt_box_hurt(hit_box):
	motion_controller.apply_impulse((global_position - hit_box.global_position).normalized() * 0.7 * hit_box.knockback)
	if (second_phase == false && health_checker.get_health() <= health_checker.max_health * 0.5):
		var ring_num: int = 6 - health_checker.get_health() / health_checker.max_health * 10
		print(ring_num) 
		second_phase = true
		#if (health_checker.get_health() <= health_checker.max_health * 0.3):
		summon_voles(ring_num)
		#else:
			#summon_voles(0)
