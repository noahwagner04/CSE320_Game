extends Node2D

@export var spawn_global: bool = false
@export_range(0, 1, 0.01, "or_greater", "suffix:s") var attack_speed : float = 0.5
@onready var Swing: PackedScene = preload("res://src/projectiles/swing.tscn")
var timer: Timer = Timer.new()
var last_click_spawn: float = 0



func _ready():
	timer.wait_time = attack_speed
	timer.timeout.connect(spawn_mouse_attack)
	add_child(timer)

func spawn_mouse_attack():
	var mouse_pos = get_global_mouse_position()
	var swing_instance = Swing.instantiate()
	swing_instance.rotation = (mouse_pos - global_position).angle()
	swing_instance.find_child("Sprite2D").flip_v = false if abs(swing_instance.rotation) < PI / 2 else true
	if spawn_global:
		swing_instance.position = global_position
		get_node("/root").add_child(swing_instance)
	else:
		add_child(swing_instance)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.pressed == true:
			var delta_click_time = Time.get_ticks_msec() / 1000.0 - last_click_spawn
			if delta_click_time > attack_speed:
				spawn_mouse_attack()
				last_click_spawn = Time.get_ticks_msec() / 1000.0
				$swingsound.play()
			timer.start()
		elif event.button_index == 1 && event.pressed == false:
			timer.stop()
