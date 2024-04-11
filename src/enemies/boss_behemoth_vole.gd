extends CharacterBody2D

@export var agro_dist: float = 375
@export var max_too_close_dist: float = 80
@export_range(0, 12, 1) var total_vomit_amount: int = 8

var _is_backstepping: bool = false
var _backstep_timer:= Timer.new()
var _giant_vole_scene: PackedScene = preload("res://src/enemies/giant_vole.tscn")
var _is_player_close: bool = false
var _move_dir: Vector2
var _player_dist: float
var _second_phase: bool = false
var _special_timer:= Timer.new()
var _vomit_proj_scene: PackedScene = preload("res://src/projectiles/vomit_projectile.tscn")
var _vomits: int = 0

@onready var _head_hit_box_shape: CollisionShape2D = %HeadHitBoxShape2D
@onready var _health_container: HealthContainer = $HealthContainer
@onready var _max_hp: float = _health_container.max_health
@onready var _motion_controller: MotionController = $MotionController
@onready var _player: Node = get_tree().get_first_node_in_group("player")
@onready var _start_position: Vector2 = global_position
@onready var _xp_dropper = $xp_dropper


func _ready():
	_special_timer.timeout.connect(_special_attacks)
	_special_timer.one_shot = true
	add_child(_special_timer)
	
	_backstep_timer.timeout.connect(_set_back_step)
	_backstep_timer.one_shot = true
	add_child(_backstep_timer)


func _process(_delta):
	if (_player == null):
		queue_free()
		return

	_player_dist = global_position.distance_to(_player.global_position)
	
	if (_player_dist > agro_dist):
		return
	
	var player_x_dist: float = _player.to_local(global_position).x
	
	if ( !_is_player_close && player_x_dist < 0 && _player_dist <= max_too_close_dist ):
		_is_player_close = true
	elif ( player_x_dist >= 0 || _player_dist > max_too_close_dist ):
		_is_player_close = false
		if ( !_is_backstepping && !_backstep_timer.is_stopped() ):
			_backstep_timer.stop()


func _physics_process(_delta):
	if (_player == null):
		queue_free()
		return
		
	if (_is_backstepping):
		if (_backstep_timer.is_stopped()):
			_backstep_timer.start(0.5)
			
		_motion_controller.move(_move_dir, _delta)
		velocity = _motion_controller.velocity * 3
		move_and_slide()
		
		return
	
	var _boss_head_pos: Vector2 = _head_hit_box_shape.global_position
	var _target: Vector2
	
	if (_player_dist <= agro_dist):
		_target = _player.global_position
		if (_special_timer.is_stopped()):
			_special_timer.start(randf_range(1, 5))
	else:
		if (global_position == _start_position):
			_health_container.heal(_delta) 
			if (_vomits != 0 && _health_container.health == _max_hp):
				_second_phase = false
				_vomits = 0
			return
		else:
			_target = _start_position
	
	_move_dir = _boss_head_pos.direction_to(_target)
	
	_motion_controller.move(_move_dir, _delta)
	velocity = _motion_controller.velocity
	move_and_slide()


func _set_back_step():
	_is_backstepping = !_is_backstepping
	if (_is_backstepping):
		_move_dir = -(global_position.direction_to(_player.global_position).normalized())


func _special_attacks():
	if ( _vomits < total_vomit_amount ):
		#if ( randf() <= 0.3 ):
		_spit_vomit()
	
	
func _spit_vomit():
	var _vomit_proj_instance: Node = _vomit_proj_scene.instantiate()
	call_deferred("add_sibling", _vomit_proj_instance, false)
	_vomits += 1
	$BearSpit.play()


func _summon_voles(ring_num):
	var angle: float
	var i: int = 1
	var giant_vole_instance: Node
	
	while i <= ring_num:
		for j in range(i * 8):
			giant_vole_instance = _giant_vole_scene.instantiate()
			
			angle = j * 0.25 / i * PI
			giant_vole_instance.global_position = global_position + 32 * (1 + i) * Vector2(cos(angle), sin(angle))
			
			call_deferred("add_sibling", giant_vole_instance, false)
			
		i += 1
	$BearSummon.play( .32 )


func _on_health_container_health_depleted():
	$BearDeath.play()
	await get_tree().create_timer(3.19).timeout
	_xp_dropper.drop_xp()
	$ItemDropper.drop()
	queue_free()


func _on_hurt_box_hurt(_hit_box):
	var curr_health: float = _health_container.health

	if ( !_is_backstepping && _is_player_close && _backstep_timer.is_stopped() ):
		_backstep_timer.start(1.5)
	
	if (_second_phase == false && !_is_backstepping && curr_health <= _max_hp * 0.5):
		_second_phase = true
		var ring_num := int(6 - curr_health / _max_hp * 10)
		_summon_voles(ring_num)
		
	$BearHurt.play( .42 )
	$HitEffectPlayer.play( "hit" )
