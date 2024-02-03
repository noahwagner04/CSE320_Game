extends Node2D

@export var projectile: PackedScene
@export var projectile_direction: Vector2 = Vector2(0.0, 0.0)
@export var projectile_speed: int = 0
@export var projectile_damage: int = 0
@export_range(5, 500, 1) var projectile_range: int = 0
@export_enum("line", "swing") var projectile_type: String = "line"
# 10 is current max, with testing this could increase:
@export_range(0, 10, 1) var chain_reactions: int = 0
	
func spawn_projectile(direction):
	projectile_direction = direction
	
	var projectile_instance = projectile.instantiate()
	projectile_instance.projectile_direction = projectile_direction
	projectile_instance.rotation = (projectile_direction).angle()
	projectile_instance.find_child("Sprite2D").flip_v = false if abs(projectile_instance.rotation) < PI / 2 else true
	projectile_instance.position = global_position
	projectile_instance.projectile_speed = projectile_speed
	projectile_instance.projectile_damage = projectile_damage
	projectile_instance.projectile_range = projectile_range
	projectile_instance.projectile_type = projectile_type
	projectile_instance.chain_reactions = chain_reactions
	get_node("/root").add_child(projectile_instance)