extends Node2D

@onready var giant_vole_timer: Timer = $GiantVoleSpawner/Timer
@onready var giant_dragonfly_timer: Timer = $GiantDragonflySpawner/Timer
@onready var boss_behemoth_vole_scene: PackedScene = preload("res://src/enemies/boss_behemoth_vole.tscn")


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


func _on_area_2d_body_entered(body):
	var collision_shape: Node = $Area2D/CollisionShape2D
	collision_shape.set_deferred("disabled", true)
	
	var behemoth_boss: Node = boss_behemoth_vole_scene.instantiate()
	behemoth_boss.global_position = collision_shape.global_position
	call_deferred("add_child", behemoth_boss)
