extends Node2D

@export var projectile: PackedScene
@export var projectile_direction: Vector2 = Vector2(0.0, 0.0)
@export var projectile_damage: float = 0
@export var projectile_speed: float = 0
@export_range(5, 500, 1) var projectile_range: float = 0
@export_enum("line", "swing") var projectile_type: String = "line"
@export var projectile_aoe_explosion: bool = false
@onready var poison_component = $PoisonComponent
@onready var knockback_component = $KnockbackComponent

	
func spawn_projectile(direction):
	projectile_direction = direction
	
	var projectile_instance = projectile.instantiate()
	projectile_instance.projectile_direction = projectile_direction
	projectile_instance.rotation = (projectile_direction).angle()
	projectile_instance.find_child("Sprite2D").flip_v = false if abs(projectile_instance.rotation) < PI / 2 else true
	projectile_instance.find_child("Sprite2D").flip_h = false if abs(projectile_instance.rotation) < PI else true
	projectile_instance.position = global_position
	set_projectile_instance_values(projectile_instance)
	get_node("/root").add_child(projectile_instance)
	set_poison_projectile_instance_values(projectile_instance)
	set_knockback_projectile_instance_values(projectile_instance)

func spawn_melee_projectile(direction):
	projectile_direction = direction
	
	var projectile_instance = projectile.instantiate()
	projectile_instance.projectile_direction = projectile_direction
	projectile_instance.rotation = (projectile_direction).angle()
	projectile_instance.find_child("Sprite2D").flip_v = false if abs(projectile_instance.rotation) < PI / 2 else true
	projectile_instance.position = position
	set_projectile_instance_values(projectile_instance)
	add_child(projectile_instance)
	set_poison_projectile_instance_values(projectile_instance)
	set_knockback_projectile_instance_values(projectile_instance)
	
func set_projectile_instance_values(projectile_instance):
	projectile_instance.projectile_speed = projectile_speed
	projectile_instance.projectile_damage = projectile_damage
	projectile_instance.projectile_range = projectile_range
	projectile_instance.projectile_type = projectile_type
	projectile_instance.aoe_explosion = projectile_aoe_explosion
	return
	
func set_universal_projectile_attributes(damage, speed, range, type):
	projectile_damage = damage
	projectile_speed = speed
	projectile_range = range
	projectile_type = type
	
func set_poison_projectile_attributes(effect_active, percent_of_max_health_per_second, duration):
	poison_component.effect_active = effect_active
	poison_component.percent_of_max_health_per_second = percent_of_max_health_per_second
	poison_component.duration = duration

func set_poison_projectile_instance_values(projectile_instance):
	projectile_instance.find_child("HitBox").set_poison(poison_component.effect_active,
		poison_component.percent_of_max_health_per_second, poison_component.duration)

func set_knockback_projectile_attributes(effect_active, knockback):
	knockback_component.effect_active = effect_active
	knockback_component.knockback = knockback
	
func set_knockback_projectile_instance_values(projectile_instance):
	projectile_instance.find_child("HitBox").set_knockback(knockback_component.effect_active,
	knockback_component.knockback)
