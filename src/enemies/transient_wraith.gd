extends CharacterBody2D

@export var projectile_cooldown: float = 0.5
@export var teleport_cooldown: float = 3
@export var teleport_range: float = 150

# NOTE: The following 3 variables are used for calculating the boundaries for which the transient wraith
# must teleport within. Arena x length is the total length of the arena, and arena y width the total
# width (Assuming the arena is a rectangle, regardless of actual shape)
@export var arena_x_length: float = 895
@export var arena_y_width: float = 319
@export var distance_from_wall: float = 5

var _half_arena_length: float = 0.5 * arena_x_length
var _half_arena_width: float = 0.5 * arena_y_width
var _home_position: Vector2
var _player_direction: Vector2
var _projectile_timer:= Timer.new()
var _second_phase: bool = false
var _special_attack_timer:= Timer.new()
var _teleport_timer:= Timer.new()

@onready var _projectile_spawner: Node2D = $ProjectileSpawner
@onready var health_container: HealthContainer = $HealthContainer
@onready var _player: Node = get_tree().get_first_node_in_group("player")


func _ready():
	add_to_group("transient_wraiths")
	
	_projectile_timer.timeout.connect(_fire_projectile)
	_special_attack_timer.timeout.connect(_special_attacks)
	_teleport_timer.timeout.connect(teleport)
	
	_special_attack_timer.one_shot = true
	
	add_child(_projectile_timer)
	add_child(_special_attack_timer)
	add_child(_teleport_timer)
	
	_projectile_timer.start(projectile_cooldown)
	_special_attack_timer.start(randf_range(15, 30))
	_teleport_timer.start(teleport_cooldown)
	
	global_position = get_node("../BossSpawnArea").global_position
	_home_position = global_position


func _physics_process(_delta):
	if _player == null:
		_player = get_tree().get_first_node_in_group("player")
		return
		
	_player_direction = to_local(_player.global_position).normalized()


func _fire_projectile():
	if (_player == null):
		return
	
	var random_angle := Vector2(randf_range(-PI/6, PI/6), randf_range(-PI/6, PI/6)) 
	_projectile_spawner.spawn_projectile(_player_direction + random_angle)
	
	
func _special_attacks():
	_split_body()
	_special_attack_timer.start(randf_range(15, 30))
	
	
func _split_body():
	if (health_container.health <= 0.25 * health_container.max_health):
		var first_wraith = get_tree().get_first_node_in_group("transient_wraiths")
		if (first_wraith != null):
			first_wraith.health_container.max_health *= 2
			first_wraith.health_container.heal(health_container.health)
		return
		
	var nodes = get_tree().get_nodes_in_group("transient_wraiths")
	
	if (nodes.size() >= 4):
		return 
	
	var split_health: float = 0.5 * health_container.health 
	var new_wraith: Node = duplicate()
	
	call_deferred("add_sibling", new_wraith, false)
	
	new_wraith.teleport()
	
	if not new_wraith.is_node_ready():
		await new_wraith.ready
		
	health_container.health = split_health
	new_wraith.health_container.health = split_health
	new_wraith.health_container.max_health = split_health
	
	
func teleport():
	if (_player == null):
		return
		
	var global_x: float
	var global_y: float
	var rand_pos: float
	var new_x_pos: float
	var new_y_pos: float
		
	if (global_position.distance_to(_player.global_position) <= 250):
		global_x = global_position.x
		global_y = global_position.y
		
		rand_pos  = randf_range(-teleport_range,teleport_range)
		new_x_pos = rand_pos + global_x
		
		if (new_x_pos > _home_position.x + _half_arena_length):
			new_x_pos = _home_position.x + _half_arena_length - distance_from_wall
		elif (new_x_pos < _home_position.x - _half_arena_length):
			new_x_pos = _home_position.x - _half_arena_length + distance_from_wall
		
		rand_pos  = randf_range(-teleport_range,teleport_range)
		new_y_pos = rand_pos + global_y
		
		if (new_y_pos > _home_position.y + _half_arena_width):
			new_y_pos = _home_position.y + _half_arena_width - distance_from_wall
		elif (new_y_pos < _home_position.y - _half_arena_width):
			new_y_pos = _home_position.y - _half_arena_width + distance_from_wall
		
		global_position = Vector2(new_x_pos, new_y_pos)


func _on_health_container_health_depleted():
	# DEBUG
	#print("freeing wraith boss")
	queue_free()


func _on_hurt_box_hurt(_hit_box):
	if (_second_phase == false && health_container.health <= health_container.max_health * 0.5):
		_second_phase = true
		_teleport_timer.start(teleport_cooldown / 2)
		_projectile_timer.start(projectile_cooldown / 2)
		
