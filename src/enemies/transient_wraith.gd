extends CharacterBody2D


var projectile_timer:= Timer.new()
var player_direction: Vector2

@onready var projectile_spawner: Node2D = $ProjectileSpawner
@onready var player: Node = get_tree().get_first_node_in_group("player")


func _ready():
	projectile_timer.timeout.connect(fire_projectile)
	add_child(projectile_timer)
	projectile_timer.start(1)


func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return
		
	player_direction = to_local(player.global_position).normalized()
	


func fire_projectile():
	projectile_spawner.spawn_projectile(player_direction)
