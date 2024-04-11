extends Node

@export var sounds: Array[ Resource ]

@export var pitch: float = 1

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func playsound( sounds, audioplayer ):
	var num = sounds.size()
	var random = randi_range( 0, num )
	var mp3 = sounds[ num ]
	if !( audioplayer.is_playing() ):
		audioplayer.stream = mp3
		audioplayer.play()

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
