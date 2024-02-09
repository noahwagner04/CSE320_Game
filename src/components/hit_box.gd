class_name HitBox 
extends Area2D

enum ResponseType {NO_RESPONSE, DISABLE, TEMPORARY_DISABLE}

@export var damage: float = 1
@export var knockback: float = 0
@export var response: ResponseType = ResponseType.NO_RESPONSE
@export_range(0.001, 60, 0.001, "or_greater", "suffix:s") 
var disable_time: float = 1


func _on_area_entered(_area):
	match response:
		ResponseType.DISABLE:
			set_deferred("monitoring", false)
		ResponseType.TEMPORARY_DISABLE:
			set_deferred("monitoring", false)
			await get_tree().create_timer(disable_time).timeout
			set_deferred("monitoring", true)
		_:
			return
