extends Node2D

@export var projectile_direction: Vector2 = Vector2(0.0, 0.0)
@export var projectile_speed: float = 200
@export var projectile_damage: float = 10
@export_range(5, 500, 1) var projectile_range: float = 5000
@export_enum("line", "swing") var projectile_type: String = "line"
@export var aoe_explosion: bool = false
@export var knockback: float = 0

var explosion: PackedScene = preload("res://src/projectiles/explosion.tscn")

func _ready():
	var projectile_lifetime = projectile_range / projectile_speed
	$HitBox.damage = projectile_damage
	await get_tree().create_timer(projectile_lifetime).timeout
	queue_free()


func _process(_delta):
	position += projectile_direction * _delta * projectile_speed


func explode():
	if aoe_explosion == true:
		var explosion_instance = explosion.instantiate()
		add_child(explosion_instance)


func _on_hit_box_area_entered(_area):
	explode()
