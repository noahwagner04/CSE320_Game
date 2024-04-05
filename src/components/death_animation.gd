extends Node2D

var life_time: float
var sound_offset: float

func play():
	%AnimationPlayer.play("death_animation")
	%AudioStreamPlayer2D.play(sound_offset)
	%CPUParticles2D.set_emitting(true)
	await get_tree().create_timer(life_time).timeout
	queue_free()
