extends GutTest

var spawner: Spawner
var spawn_scene: PackedScene = preload("res://src/enemies/giant_vole.tscn")

func before_each():
	spawner = preload("res://src/components/spawner.tscn").instantiate()
	add_child_autofree(spawner)
	spawner.scene = spawn_scene


func test_start_spawning():
	pass


func test_spawn_signal():
	pass


func test_spawn():
	pass
