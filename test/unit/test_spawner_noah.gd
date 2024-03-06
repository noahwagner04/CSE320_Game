extends GutTest

var spawner: Spawner
var node2d_spawn_scene: PackedScene = preload("res://src/enemies/giant_vole.tscn")
var node_spawn_scene: PackedScene = preload("res://src/components/health_container.tscn")


func before_each():
	spawner = preload("res://src/components/spawner.tscn").instantiate()
	add_child_autofree(spawner)
	spawner.scene = node2d_spawn_scene


func test_spawn_max():
	spawner.max_spawn = 0
	spawner.spawn()
	assert_true(spawner.get_child_count() == 1, "spawner must not spawn more than max_spawn")


func test_spawn_node2d():
	spawner.spawn()
	assert_true(spawner.get_child_count() == 2, "spawner must not spawn more than max_spawn")


func test_spawn_node():
	spawner.scene = node_spawn_scene
	spawner.spawn()
	assert_true(spawner.get_child_count() == 2, "spawner must not spawn more than max_spawn")
