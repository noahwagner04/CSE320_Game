extends CharacterBody2D


var projectile_timer:= Timer.new()
var teleport_timer:= Timer.new()
var player_direction: Vector2

@onready var projectile_spawner: Node2D = $ProjectileSpawner
@onready var player: Node = get_tree().get_first_node_in_group("player")


func _ready():
	projectile_timer.timeout.connect(fire_projectile)
	teleport_timer.timeout.connect(teleport)
	teleport_timer.one_shot = true
	add_child(teleport_timer)
	add_child(projectile_timer)
	teleport_timer.start(3)
	projectile_timer.start(1)


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
	if (to_local(player.global_position) <= Vector2(15,15)):
		var global_x: float = global_position.x
		var global_y: float = global_position.y
		
		var new_x_pos: float = randf_range(-250,250)
		while  (new_x_pos + global_x > 640 || new_x_pos + global_x < -640):
			new_x_pos = randf_range(-250, 250)
		
		var new_y_pos: float = randf_range(-250,250)
		while (new_y_pos + global_y > 640 || new_y_pos + global_y < -640):
			new_y_pos = randf_range(-250, 250)
		
		global_position += Vector2(new_x_pos, new_y_pos)
		teleport_timer.start(3)
	else:
		teleport_timer.start(1)


func _on_health_container_health_depleted():
	queue_free()
