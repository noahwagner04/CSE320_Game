extends CharacterBody2D

@export var agro_dist: float = 300
@export_range(0, 12, 1) var total_vomit_amount: int = 5

var _target: Node2D
var vomits: int = 0
var player_dist: float

@onready var giant_vole_scene: PackedScene = preload("res://src/enemies/giant_vole.tscn")
@onready var health_container: HealthContainer = $HealthContainer
@onready var motion_controller: MotionController = $MotionController
@onready var player: Node = get_tree().get_first_node_in_group("player")
@onready var second_phase: bool = false
@onready var special_timer:= Timer.new()
@onready var start_position: Vector2 = global_position
@onready var vomit_proj_scene: PackedScene = preload("res://src/projectiles/vomit_projectile.tscn")


func _ready():
	special_timer.timeout.connect(special_attacks)
	special_timer.one_shot = true
	add_child(special_timer)


func _physics_process(_delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return
	
	player_dist = global_position.distance_to(player.global_position)
	if player_dist <= agro_dist:
		_target = player
		agro_dist = 450
		if (vomits < total_vomit_amount && special_timer.is_stopped()):
			special_timer.start(randf_range(1, 5))
	else:
		_target = null
		agro_dist = 300
		vomits = 0
		health_container.health = health_container.max_health
	
	if (_target != null):
		motion_controller.acc_dir = global_position.direction_to(_target.global_position)
	else:
		motion_controller.acc_dir = global_position.direction_to(start_position)
	
	motion_controller.update(_delta)
	velocity = motion_controller.get_velocity()
	move_and_slide()


func special_attacks():
	if ( vomits < total_vomit_amount ):
		#if ( randf() <= 0.3 ):
		spit_vomit()
	
	
func spit_vomit():
	var vomit_proj_instance: Node = vomit_proj_scene.instantiate()
	call_deferred("add_sibling", vomit_proj_instance, false)
	vomits += 1


func summon_voles(ring_num):
	var angle: float
	var i: int = 1
	var giant_vole_instance: Node
	
	while i <= ring_num:
		for j in range(i * 8):
			giant_vole_instance = giant_vole_scene.instantiate()
			
			angle = j * 0.25 / i * PI
			giant_vole_instance.global_position = global_position + 32 * (1 + i) * Vector2(cos(angle), sin(angle))
			
			call_deferred("add_sibling", giant_vole_instance, false)
			
		i += 1
	$BearSummon.play( .32 )
	
	
func _on_health_container_health_depleted():
	$BearDeath.play( )
	await get_tree().create_timer( 3.19 ).timeout
	queue_free()


func _on_hurt_box_hurt(hit_box):
	motion_controller.apply_impulse((global_position - hit_box.global_position).normalized() * 0.7 * hit_box.knockback)
	if (second_phase == false && health_container.health <= health_container.max_health * 0.5):
		second_phase = true
		var ring_num: int = 6 - health_container.health / health_container.max_health * 10
		summon_voles(ring_num)
	$BearHurt.play( .42 )
