extends CharacterBody2D

@export var agro_dist: float = 450
@export_range(0, 12, 1) var total_vomit_amount: int = 8
@onready var xp_dropper = $xp_dropper

var back_step_timer:= Timer.new()
var giant_vole_scene: PackedScene = preload("res://src/enemies/giant_vole.tscn")
var second_phase: bool = false
var special_timer:= Timer.new()
var vomit_proj_scene: PackedScene = preload("res://src/projectiles/vomit_projectile.tscn")
var vomits: int = 0

@onready var head_hit_box_shape: CollisionShape2D = %HeadHitBoxShape2D
@onready var health_container: HealthContainer = $HealthContainer
@onready var max_hp: float = health_container.max_health
@onready var motion_controller: MotionController = $MotionController
@onready var player: Node = get_tree().get_first_node_in_group("player")
@onready var start_position: Vector2 = global_position


func _ready():
	special_timer.timeout.connect(special_attacks)
	special_timer.one_shot = true
	add_child(special_timer)
	
	back_step_timer.timeout.connect(back_step)
	back_step_timer.one_shot = true
	add_child(back_step_timer)


func _physics_process(_delta):
	if (player == null):
		queue_free()
		return
	
	var player_dist: float = global_position.distance_to(player.global_position)
	var _boss_head_pos: Vector2 = head_hit_box_shape.global_position
	var _target: Vector2
	
	if (player_dist <= agro_dist):
		_target = player.global_position
		if (special_timer.is_stopped()):
			special_timer.start(randf_range(1, 5))
	else:
		if (global_position == start_position):
			health_container.heal(_delta) 
			if (vomits != 0 && health_container.health == max_hp):
				second_phase = false
				vomits = 0
			return
		else:
			_target = start_position
	
	var move_dir: Vector2 = _boss_head_pos.direction_to(_target)
	
	motion_controller.move(move_dir, _delta)
	velocity = motion_controller.velocity
	move_and_slide()


func back_step():
	#print("in back_step()")
	pass
	#var move_dir: Vector2 = -global_position.direction_to(player.global_position)
	#motion_controller.move(move_dir, get_physics_process_delta_time())
	#velocity = motion_controller.velocity * 10
	#move_and_slide()


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
	xp_dropper.drop_xp()
	$BearDeath.play( )
	await get_tree().create_timer( 3.19 ).timeout
	$ItemDropper.on_death()
	queue_free()


func _on_hurt_box_hurt(_hit_box):
	var curr_health: float = health_container.health
	var player_dist: float = player.global_position.x - global_position.x 
	
	if (!back_step_timer.is_stopped() && player_dist > 75):
		back_step_timer.stop() 
	elif (back_step_timer.is_stopped() && player_dist <= 75):
		back_step_timer.start(2)
	
	if (second_phase == false && curr_health <= max_hp * 0.5):
		second_phase = true
		var ring_num := int(6 - curr_health / max_hp * 10)
		summon_voles(ring_num)
		
	$BearHurt.play( .42 )
