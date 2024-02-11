extends Node2D

@export var projectile: PackedScene
@export var projectile_direction: Vector2 = Vector2(0.0, 0.0)
@export var projectile_speed: float = 0
@export var projectile_damage: float = 0
@export_range(5, 500, 1) var projectile_range: float = 0
@export_enum("line", "swing") var projectile_type: String = "line"
@export var aoe_explosion: bool = false
	
func spawn_projectile(direction):
	projectile_direction = direction
	
	var projectile_instance = projectile.instantiate()
	projectile_instance.projectile_direction = projectile_direction
	projectile_instance.rotation = (projectile_direction).angle()
	projectile_instance.find_child("Sprite2D").flip_v = false if abs(projectile_instance.rotation) < PI / 2 else true
	projectile_instance.position = global_position
	set_projectile_values(projectile_instance)
	get_node("/root").add_child(projectile_instance)

func spawn_melee_projectile(direction):
	projectile_direction = direction
	
	var projectile_instance = projectile.instantiate()
	projectile_instance.projectile_direction = projectile_direction
	projectile_instance.rotation = (projectile_direction).angle()
	projectile_instance.find_child("Sprite2D").flip_v = false if abs(projectile_instance.rotation) < PI / 2 else true
	projectile_instance.position = position
	set_projectile_values(projectile_instance)
	add_child(projectile_instance)
	
func set_projectile_values(projectile_instance):
	projectile_instance.projectile_speed = projectile_speed
	projectile_instance.projectile_damage = projectile_damage
	projectile_instance.projectile_range = projectile_range
	projectile_instance.projectile_type = projectile_type
	projectile_instance.aoe_explosion = aoe_explosion
	return
