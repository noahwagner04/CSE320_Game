extends Node2D

@export var projectile_speed: float = 70
@export var projectile_damage: float = 20
@export_range(5, 500, 1) var projectile_range: float = 150
@export var knockback: float = 0

#@onready var behemoth_vole_position: Vector2 = get_node("../behemoth_vole_boss").global_position
@onready var player: Node = get_tree().get_first_node_in_group("player")
@onready var projectile_direction: Vector2 = to_local(player.global_position).normalized()


func _ready():
	var projectile_lifetime = projectile_range / projectile_speed
	$HitBox.damage = projectile_damage
	$HitBox.knockback = knockback
	await get_tree().create_timer(projectile_lifetime).timeout
	queue_free()


func _process(delta):
	position += projectile_direction * delta * projectile_speed
