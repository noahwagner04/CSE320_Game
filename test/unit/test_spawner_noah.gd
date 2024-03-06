extends GutTest

var spawner: Spawner
var node2d_spawn_scene: PackedScene = preload("res://src/enemies/giant_vole.tscn")
var node_spawn_scene: PackedScene = preload("res://src/components/health_container.tscn")


func before_each():
	spawner = preload("res://src/components/spawner.tscn").instantiate()
	add_child_autofree(spawner)
	spawner.scene = node2d_spawn_scene

# the three tests below are testing this spawn function from the Spawner class
'''
func spawn():
	if spawned_count >= max_spawn:
		return
	var instance = scene.instantiate()
	if instance is Node2D:
		var angle = randf() * 2 * PI
		instance.position = Vector2(cos(angle), sin(angle)) * radius * randf()
	instance.tree_exited.connect(_on_despawn)
	if(spawn_as_child):
		add_child(instance, true)
	else:
		_root.add_child(instance, true)
	spawned_count += 1
	emit_signal("scene_spawned", instance)
'''

# along with test_spawn_node2d and test_spawn_node, achieves 83% branch coverage
func test_spawn_max():
	spawner.max_spawn = 0
	spawner.spawn()
	assert_true(spawner.get_child_count() == 1, "spawner must not spawn more than max_spawn")


# along with test_spawn_node2d and test_spawn_node, achieves 83% branch coverage
func test_spawn_node2d():
	spawner.spawn()
	assert_true(spawner.get_child_count() == 2, "spawner must not spawn more than max_spawn")


# along with test_spawn_node2d and test_spawn_node, achieves 83% branch coverage
func test_spawn_node():
	spawner.scene = node_spawn_scene
	spawner.spawn()
	assert_true(spawner.get_child_count() == 2, "spawner must not spawn more than max_spawn")
