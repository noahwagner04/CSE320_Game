extends Node2D

@export var damage: float = 20
@export var knockback: float = 0
var explosion_lifetime: float = 0.2

func _ready():
	$HitBox.set_basic_attributes(damage, knockback)
	await get_tree().create_timer(explosion_lifetime).timeout
	queue_free()
