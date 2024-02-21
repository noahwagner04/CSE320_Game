@tool
class_name Spawner
extends Marker2D

@export_range(0.001, 60, 0.001, "or_greater", "suffix:s") 
var frequency: float = 1
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

var spawned_count: int = 0
var timer: Timer = Timer.new()


func _ready():
	timer.timeout.connect(spawn)
	add_child(timer)


func _draw():
	if Engine.is_editor_hint() and debug:
		draw_circle(Vector2.ZERO, radius, Color(1, 1, 0, 0.3))


func _get_configuration_warnings():
	if scene == null:
		return ["Scene to spawn is not set!"]
	elif not (scene.instantiate() is Node2D):
		return ["Provided scene must extend Node2D for Spawner to work."]


func spawn():
	if spawned_count >= max_spawn:
		return
	var instance = scene.instantiate()
	if instance is Node2D:
		var angle = randf() * 2 * PI
		instance.position = Vector2(cos(angle), sin(angle)) * radius * randf()
		instance.tree_exited.connect(_on_despawn)
	add_child(instance, true)
	spawned_count += 1


func start_spawning(new_frequency : float = frequency):
	if new_frequency != frequency:
		frequency = new_frequency
	timer.start(frequency)


func stop_spawning():
	timer.stop()


func _on_despawn():
	spawned_count -= 1
