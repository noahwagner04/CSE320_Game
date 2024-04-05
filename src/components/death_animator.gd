extends Node2D

@export var sprite: Texture
@export var sound_effect: AudioStream
@export var sound_offset: float
@export var life_time: float = 1

var death_animation: PackedScene = preload("res://src/components/death_animation.tscn")

func animate():
	var death_instance = death_animation.instantiate()
	death_instance.global_position = global_position
	get_tree().get_root().call_deferred("add_child", death_instance)
	
	var children = death_instance.get_children(true)
	var sprite2d: Sprite2D = children.filter(func (child): return child is Sprite2D)[0]
	var audio_stream: AudioStreamPlayer2D = children.filter(func (child): return child is AudioStreamPlayer2D)[0]
	
	sprite2d.set_texture(sprite)
	audio_stream.set_stream(sound_effect)
	death_instance.life_time = life_time
	death_instance.sound_offset = sound_offset
	
	death_instance.call_deferred("play")
