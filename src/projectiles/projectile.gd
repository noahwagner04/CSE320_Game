extends Node2D
class_name Projectile

var projectile_direction: Vector2 = Vector2(0.0, 0.0)
var projectile_speed: float = 100
var projectile_damage: float = 10
var projectile_range: float = 50
var projectile_type: String = "line"
var aoe_explosion: bool = false

func _ready():
	var projectile_lifetime = projectile_range / projectile_speed
	$HitBox.set_damage(projectile_damage)
	await get_tree().create_timer(projectile_lifetime).timeout
	queue_free()

func _process(_delta):
	position += projectile_direction * _delta * projectile_speed
