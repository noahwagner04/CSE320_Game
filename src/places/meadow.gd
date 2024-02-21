extends Node2D

@onready var giant_vole_spawner: Spawner = %GiantVoleSpawner


func _ready():
	if multiplayer.is_server():
		giant_vole_spawner.start_spawning()
		increase_difficulty()

func increase_difficulty():
	get_tree().create_timer(10).timeout.connect(increase_difficulty)
	giant_vole_spawner.start_spawning(
			giant_vole_spawner.frequency - giant_vole_spawner.frequency * 0.1)
