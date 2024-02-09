extends Node2D

@export var damage: int = 20
var explosion_lifetime: float = 0.2

func _ready():
	$HitBox.damage = damage
	await get_tree().create_timer(explosion_lifetime).timeout
	queue_free()
