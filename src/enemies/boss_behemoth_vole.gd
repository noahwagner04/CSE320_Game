extends CharacterBody2D

@export var agro_dist: float = 300

var _rand_target_mod := Vector2((randf() * 2 - 1) * 10, (randf() * 2 - 1) * 10)
var _target: Node2D

@onready var player: Node = get_tree().get_first_node_in_group("player")
@onready var motion_controller: MotionController = %MotionController
@onready var health_checker: HealthContainer = %HealthContainer
@onready var second_phase: bool = false

func _physics_process(_delta):
	var player_dist = agro_dist + 1
	if player != null:
		player_dist = global_position.distance_to(player.global_position)
	if player_dist < agro_dist:
		_target = player
		agro_dist = 450
	else:
		if (player == null):
			player = get_tree().get_first_node_in_group("player")
		return
	
	var new_target = _target.global_position + _rand_target_mod
	
	motion_controller.acc_dir = global_position.direction_to(new_target)
	motion_controller.update(_delta)
	velocity = motion_controller.get_velocity()
	move_and_slide()
	
func summon_voles():
	var angle: float
	var giant_vole_scene: PackedScene = preload("res://src/enemies/giant_vole.tscn")
	var vole_guard: Node
	
	for i in 8:
		vole_guard = giant_vole_scene.instantiate()
		
		angle = i * 0.25 * PI
		vole_guard.global_position = player.global_position + 96 * Vector2(cos(angle), sin(angle))
		
		call_deferred("add_sibling", vole_guard, false)

func _on_health_container_health_depleted():
	queue_free()

func _on_hurt_box_hurt(hit_box):
	motion_controller.apply_impulse((global_position - hit_box.global_position).normalized() * 0.7 * hit_box.knockback)
	if (second_phase == false && health_checker.get_health() <= health_checker.max_health / 2):
		second_phase = true
		summon_voles()
