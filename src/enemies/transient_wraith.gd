extends CharacterBody2D


@export var teleport_range: float = 400
@export var teleport_cooldown: float = 3
@export var projectile_cooldown: float = 0.5

var projectile_timer:= Timer.new()
var teleport_timer:= Timer.new()
var player_direction: Vector2
var second_phase: bool = false

@onready var projectile_spawner: Node2D = $ProjectileSpawner
@onready var health_container: HealthContainer = $HealthContainer
@onready var player: Node = get_tree().get_first_node_in_group("player")


func _ready():
	projectile_timer.timeout.connect(fire_projectile)
	teleport_timer.timeout.connect(teleport)
	#teleport_timer.one_shot = true
	add_child(teleport_timer)
	add_child(projectile_timer)
	teleport_timer.start(teleport_cooldown)
	projectile_timer.start(projectile_cooldown)


func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return
		
	player_direction = to_local(player.global_position).normalized()


func fire_projectile():
	if (player == null):
		return
	projectile_spawner.spawn_projectile(player_direction)
	
	
func teleport():
	if (player == null):
		return
		
	var global_x: float
	var global_y: float
	var rand_pos: float
	var new_x_pos: float
	var new_y_pos: float
		
	if (global_position.distance_to(player.global_position) <= 250):
		global_x = global_position.x
		global_y = global_position.y
		
		rand_pos  = randf_range(-teleport_range,teleport_range)
		new_x_pos = rand_pos + global_x
		
		if (new_x_pos > 640):
			new_x_pos = 640 
		elif (new_x_pos < -640):
			new_x_pos = -640
		
		rand_pos  = randf_range(-teleport_range,teleport_range)
		new_y_pos = rand_pos + global_y
		
		if (new_y_pos > 640):
			new_y_pos = 640
		elif (new_y_pos < -640):
			new_y_pos = -640
		
		global_position = Vector2(new_x_pos, new_y_pos)
	
		#teleport_timer.start(teleport_cooldown)


func _on_health_container_health_depleted():
	print("freeing wraith boss")
	queue_free()


func _on_hurt_box_hurt(hit_box):
	if (second_phase == false && health_container.health <= health_container.max_health * 0.5):
		second_phase = true
		#teleport_cooldown = teleport_cooldown / 2
		teleport_timer.start(teleport_cooldown / 2)
		projectile_timer.start(projectile_cooldown / 2)
		
