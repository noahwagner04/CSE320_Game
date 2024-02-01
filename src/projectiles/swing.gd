extends Node2D

@export var speed: float = 300
@export_range(0, 10, 0.01, "or_greater", "suffix:s") var lifetime : float = 0.1

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(_delta):
	position += Vector2(1, 0).rotated(rotation) * _delta * speed
