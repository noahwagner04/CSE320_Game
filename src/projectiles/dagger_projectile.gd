extends Node2D

@export var projectile_direction: Vector2 = Vector2(0.0, 0.0)
@export var projectile_speed: float = 100
@export var projectile_damage: float = 10
@export_range(5, 500, 1) var projectile_range: float = 50
@export_enum("line", "swing") var projectile_type: String = "line"
@export var aoe_explosion: bool = false

var projectile_lifetime: float = projectile_range / projectile_speed

func _ready():
	projectile_lifetime = projectile_range / projectile_speed
	$HitBox.damage = projectile_damage
	await get_tree().create_timer(projectile_lifetime).timeout
	queue_free()

func _process(_delta):
	position += projectile_direction * _delta * projectile_speed
