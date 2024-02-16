class_name HitBox 
extends Area2D

enum ResponseType {NO_RESPONSE, DISABLE, TEMPORARY_DISABLE}

@export var damage: float = 1
@export var knockback: float = 0
@export var response := ResponseType.NO_RESPONSE
@export_range(0.001, 60, 0.001, "or_greater", "suffix:s")
var disable_time: float = 1

@onready var poison_component: Node = $PoisonComponent


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
			
func set_basic_attributes(damage_param, knockback_param):
	damage = damage_param
	knockback = knockback_param

func set_poison(active_param, percent_param, duration_param):
	$PoisonComponent.effect_active = active_param
	$PoisonComponent.percent_of_max_health_per_second = percent_param
	$PoisonComponent.duration = duration_param
