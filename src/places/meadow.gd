extends Node2D

@onready var giant_vole_spawner : Spawner = %GiantVoleSpawner

func _ready():
	giant_vole_spawner.start_spawning()
