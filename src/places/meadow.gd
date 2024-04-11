extends Node2D

@onready var giant_vole_timer: Timer = $GiantVoleSpawner/Timer
@onready var giant_dragonfly_timer: Timer = $GiantDragonflySpawner/Timer
@onready var bat_timer: Timer = $BatSpawner/Timer
@onready var boss_behemoth_vole_scene: PackedScene = preload("res://src/enemies/boss_behemoth_vole.tscn")
@onready var transient_wraith_scene: PackedScene = preload("res://src/enemies/transient_wraith.tscn")


func _ready():
	if multiplayer.is_server():
		giant_vole_timer.start()
		giant_dragonfly_timer.start()
		bat_timer.start()
		increase_difficulty()


func increase_difficulty():
	get_tree().create_timer(10).timeout.connect(increase_difficulty)
	giant_vole_timer.start(
			giant_vole_timer.wait_time - giant_vole_timer.wait_time * 0.1)
	giant_dragonfly_timer.start(
			giant_dragonfly_timer.wait_time - giant_dragonfly_timer.wait_time * 0.1)


func _on_behemoth_vole_spawn_body_entered(_body):
	var collision_shape: Node = $Area2D/CollisionShape2D
	collision_shape.set_deferred("disabled", true)
	
	var behemoth_boss: Node = boss_behemoth_vole_scene.instantiate()
	behemoth_boss.global_position = collision_shape.global_position
	call_deferred("add_child", behemoth_boss)


func _on_meadow_dungeon_entrance_body_entered(_body):
	var player: Node = get_tree().get_first_node_in_group("player")
	var dungeon_exit: Node = $MeadowDungeonExit/CollisionShape2D
	
	player.global_position = dungeon_exit.global_position + Vector2(64, 0)


func _on_transient_wraith_spawn_body_entered(_body):
	var collision_shape: Node = $TransientWraithSpawn/CollisionShape2D
	collision_shape.set_deferred("disabled", true)
	
	var transient_wraith: Node = transient_wraith_scene.instantiate()
	
	call_deferred("add_child", transient_wraith, true)


func _on_meadow_dungeon_exit_body_entered(_body):
	var player: Node = get_tree().get_first_node_in_group("player")
	var dungeon_entrance: Node = $MeadowDungeonEntrance/CollisionShape2D
	
	player.global_position = dungeon_entrance.global_position + Vector2(-43, 31)
	
	if get_tree().get_first_node_in_group("transient_wraiths") != null:
		get_tree().call_group("transient_wraiths", "queue_free")
		
		var collision_shape: Node = $TransientWraithSpawn/CollisionShape2D
		collision_shape.set_deferred("disabled", false)
