extends CharacterBody2D

@export var projectile_cooldown: float = 0.5
@export var teleport_cooldown: float = 3
@export var teleport_x_range: float = 150
@export var teleport_y_range: float = 50

# NOTE: The following 5 variables are used as the boundaries for which the transient wraith
# must teleport within; the max/min x/y positions are the global x and y values 
# the wraith is confined to. The distance_from_wall variable is to provide extra space to doubly
# make sure the wraith isn't getting stuck anywhere
@export var max_x_position: int = 2424
@export var max_y_position: int = 352
@export var min_x_position: int = 1536
@export var min_y_position: int = 32
@export var distance_from_wall: float = 5

var _player_direction: Vector2
var _projectile_timer:= Timer.new()
var _second_phase: bool = false
var _special_attack_timer:= Timer.new()
var _teleport_timer:= Timer.new()

#Audio loads
var wraithtp = load("res://assets/sfx/wraithtp.mp3")
var wraithhurt = load("res://assets/sfx/wraithhurt.mp3")
var wraithdeath = load("res://assets/sfx/wraithdeath.mp3")

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
	
	global_position = get_node("../TransientWraithSpawn").global_position


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
		
	if (global_position.distance_to(_player.global_position) <= 250):
		var global_x: float = global_position.x
		var global_y: float = global_position.y
		var new_x_pos: float
		var new_y_pos: float
		var rand_pos: float
		
		rand_pos  = randf_range(-teleport_x_range,teleport_x_range)
		new_x_pos = rand_pos + global_x
		
		if (new_x_pos > max_x_position):
			new_x_pos = max_x_position - distance_from_wall
		elif (new_x_pos < min_x_position):
			new_x_pos = min_x_position + distance_from_wall
		
		rand_pos  = randf_range(-teleport_y_range,teleport_y_range)
		new_y_pos = rand_pos + global_y
		
		if (new_y_pos > max_y_position):
			new_y_pos = max_y_position - distance_from_wall
		elif (new_y_pos < min_y_position):
			new_y_pos = min_y_position + distance_from_wall
		
		global_position = Vector2(new_x_pos, new_y_pos)
		
		#Audio stuff here
		$WraithPlayer.stream = wraithtp
		$WraithPlayer.play()


func _on_health_container_health_depleted():
	# DEBUG
	#print("freeing wraith boss")
	queue_free()


func _on_hurt_box_hurt(_hit_box):
	if (_second_phase == false && health_container.health <= health_container.max_health * 0.5):
		_second_phase = true
		_teleport_timer.start(teleport_cooldown / 2)
		_projectile_timer.start(projectile_cooldown / 2)
	#Audio on hit
	$WraithPlayer.stream = wraithhurt
	$WraithPlayer.play()
