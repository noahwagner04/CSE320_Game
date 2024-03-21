extends Node2D

@onready var giant_vole_timer: Timer = $GiantVoleSpawner/Timer
@onready var giant_dragonfly_timer: Timer = $GiantDragonflySpawner/Timer


func _ready():
	if multiplayer.is_server():
		giant_vole_timer.start()
		giant_dragonfly_timer.start()
		increase_difficulty()


func increase_difficulty():
	get_tree().create_timer(10).timeout.connect(increase_difficulty)
	giant_vole_timer.start(
			giant_vole_timer.wait_time - giant_vole_timer.wait_time * 0.1)
	giant_dragonfly_timer.start(
			giant_dragonfly_timer.wait_time - giant_dragonfly_timer.wait_time * 0.1)
