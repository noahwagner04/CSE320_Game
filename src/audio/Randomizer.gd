extends Node

@export var sounds: Array[ Resource ]

@export var pitch: float = 1

var rng = RandomNumberGenerator.new()

# Plays a random sound from an array to allow diversity of SFX

func play_sound_from_array( sounds, audioplayer ):
	var num = sounds.size()
	var random = randi_range( 0, num )
	var mp3 = sounds[ num ]
	if !( audioplayer.is_playing() ):
		audioplayer.stream = mp3
		audioplayer.play()

func change_sound_pitch( audioplayer, pitch ):
	audioplayer.pitch_scale = pitch

