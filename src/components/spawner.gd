@tool
class_name Spawner
extends Marker2D

signal scene_spawned(scene: Node2D)

@export_range(0, 1000, 1, "or_greater", "suffix:px") 
var radius: int = 32:
	set(new_radius):
		radius = new_radius
		queue_redraw()
@export var debug: bool = true:
	set(new_debug):
		debug = new_debug
		queue_redraw()
@export var max_spawn: int = 1
@export var scene: PackedScene:
	set(new_scene):
		scene = new_scene
		update_configuration_warnings()
@export var spawn_as_child: bool = true

var spawned_count: int = 0

var _timer: Timer

@onready var _root = $/root

func _ready():
	for child in get_children():
		if child is Timer:
			_timer = child
			_timer.timeout.connect(spawn)
			break


func _draw():
	if Engine.is_editor_hint() and debug:
		draw_circle(Vector2.ZERO, radius, Color(1, 1, 0, 0.3))


func _get_configuration_warnings():
	if scene == null:
		return ["Scene to spawn is not set!"]
	elif not (scene.instantiate() is Node2D):
		return ["Provided scene must extend Node2D for Spawner to work."]
	
	var has_timer: bool = false
	for child in get_children():
		if child is Timer:
			has_timer = true
			break
	if not has_timer:
		return ["Add a child Timer node to spawn on an interval."]


func instantiate() -> Node2D:
	if spawned_count >= max_spawn:
		return null
	var instance = scene.instantiate()
	if not instance is Node2D:
		instance.queue_free()
		return null
	var angle = randf() * 2 * PI
	instance.global_position = Vector2(cos(angle), sin(angle)) * radius * randf()
	instance.global_position += global_position
	return instance


func add_to_tree(instance: Node2D):
	instance.tree_exited.connect(_on_despawn)
	if spawn_as_child:
		add_child(instance, true)
	else:
		_root.call_deferred("add_child", instance, true)
	spawned_count += 1
	emit_signal("scene_spawned", instance)


func spawn():
	var instance = instantiate()
	if instance:
		add_to_tree(instance)


func _on_despawn():
	spawned_count -= 1
