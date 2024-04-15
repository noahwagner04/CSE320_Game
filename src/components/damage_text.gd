extends Node2D

@export var scale_mod: float = 1

var damage: float = 1
var lifetime: float = 0.5
var speed: float = 20
var direction := Vector2.ZERO
var original_scale: Vector2


func _ready():
	$Label.set_text(str(damage))
	var damage_scalar = abs(damage) / 80
	scale += Vector2(1, 1) * damage_scalar
	original_scale = scale
	
	modulate = Color(1, 1 - damage_scalar, 1 - damage_scalar)
	
	var random_angle = (randf() * 2 - 1) * PI / 6
	rotation = random_angle
	random_angle -= PI / 2
	direction = Vector2(cos(random_angle), sin(random_angle))
	$AnimationPlayer.play("scale_animation")
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _process(_delta):
	scale = original_scale * scale_mod
	position += direction * speed * _delta
