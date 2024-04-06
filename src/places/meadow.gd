extends Node2D

@onready var giant_vole_timer: Timer = $GiantVoleSpawner/Timer
@onready var giant_dragonfly_timer: Timer = $GiantDragonflySpawner/Timer
@onready var boss_behemoth_vole_scene: PackedScene = preload("res://src/enemies/boss_behemoth_vole.tscn")
@onready var meadow_dungeon_scene: PackedScene = preload("res://src/places/meadow_dungeon.tscn")


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


func _on_area_2d_body_entered(_body):
	var collision_shape: Node = $Area2D/CollisionShape2D
	collision_shape.set_deferred("disabled", true)
	
	var behemoth_boss: Node = boss_behemoth_vole_scene.instantiate()
	behemoth_boss.global_position = collision_shape.global_position
	call_deferred("add_child", behemoth_boss)


func _on_meadow_dungeon_area_body_entered(body):
	var meadow_dungeon_instance: Node = meadow_dungeon_scene.instantiate()
	call_deferred("add_sibling", meadow_dungeon_instance)

	var player: Node = get_tree().get_first_node_in_group("player")
	player.global_position = Vector2(205,-409)
	
	queue_free()
