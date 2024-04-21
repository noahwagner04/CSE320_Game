extends Node2D

@export var scale_x: float

var life_time: float
var sound_offset: float
var original_x_scale: float

@onready var sprite = %Sprite2D

func play():
	%AnimationPlayer.play("death_animation")
	%AudioStreamPlayer2D.play(sound_offset)
	%CPUParticles2D.set_emitting(true)
	original_x_scale = sprite.scale.x
	await get_tree().create_timer(life_time).timeout
	queue_free()

func _process(_delta_time):
	sprite.scale.x = original_x_scale * scale_x
