extends Node2D

@onready var transient_wraith_scene: PackedScene = preload("res://src/enemies/transient_wraith.tscn")
#@onready var meadow_scene: PackedScene = preload("res://src/places/meadow.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(_body):
	var collision_shape: Node = $Area2D/CollisionShape2D
	collision_shape.set_deferred("disabled", true)
	
	var transient_wraith: Node = transient_wraith_scene.instantiate()
	
	call_deferred("add_child", transient_wraith)



func _on_leave_dungeon_area_body_entered(_body):
	pass
	#var meadow: Node = meadow_scene.instantiate()
	#
	#call_deferred("add_sibling", meadow)
	#
	#var player: Node = get_tree().get_first_node_in_group("player")
	#player.global_position = Vector2(-551,548)
	#
	#queue_free()
