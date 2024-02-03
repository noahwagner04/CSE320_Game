extends Node2D

@export var projectile_direction: Vector2 = Vector2(0.0, 0.0)
@export var projectile_speed: int = 100
@export var projectile_damage: int = 10
@export_range(5, 500, 1) var projectile_range: int = 50
@export_enum("line", "swing") var projectile_type: String = "line"
# 10 is current max, with testing this could increase:
@export_range(0, 10, 1) var chain_reactions: int = 0

var projectile_lifetime: float = projectile_speed / projectile_range

func _ready():
	$HitBox.damage = projectile_damage
	await get_tree().create_timer(projectile_lifetime).timeout
	queue_free()

func _process(_delta):
	position += projectile_direction * _delta * projectile_speed
