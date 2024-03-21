class_name HitBox 
extends Area2D

enum ResponseType {NO_RESPONSE, DISABLE, TEMPORARY_DISABLE}

@export var damage: float = 1
@export var response := ResponseType.NO_RESPONSE
@export_range(0.001, 60, 0.001, "or_greater", "suffix:s")
var disable_time: float = 1

@onready var knockback_component = $KnockbackComponent
@onready var poison_component = $PoisonComponent


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
			
func set_damage(damage_param):
	damage = damage_param


func set_poison(active_param, percent_param, duration_param):
	poison_component.effect_active = active_param
	poison_component.percent_of_max_health_per_second = percent_param
	poison_component.duration = duration_param


func set_knockback(active_param, knockback_param):
	knockback_component.effect_active = active_param
	knockback_component.knockback = knockback_param
