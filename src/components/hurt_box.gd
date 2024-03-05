class_name HurtBox 
extends Area2D

signal hurt(hit_box)

@export var health_container: HealthContainer
@export var motion_controller: MotionController
@export_range(0, 100, 1, "suffix: %") var knockback_resistance: float = 0
var is_poisoned: bool = false

@onready var poison_component: Node = $PoisonComponent
@onready var knockback_component: Node = $KnockbackComponent


func _on_area_entered(area):
	if not (area is HitBox):
		return
	if health_container != null:
		health_container.damage(area.damage)
		
	#effects
	if area.poison_component.effect_active == true:
		poison_component.effect_active = true
		poison_component.percent_of_max_health_per_second = area.poison_component.percent_of_max_health_per_second
		poison_component.duration = area.poison_component.duration
		resolve_poison()
		
	if area.knockback_component.effect_active == true:
		knockback_component.effect_active = true
		knockback_component.knockback = area.knockback_component.knockback
		resolve_knockback(area)
	
	emit_signal("hurt", area)

func resolve_poison():
	if (health_container == null) || (is_poisoned == true):
		return
	is_poisoned = true
	var damage_per_second: float = health_container.max_health * poison_component.percent_of_max_health_per_second / 100.0
	#print("max health = ", health_container.max_health)
	#print("damage_per_second = ", damage_per_second)
	var curr_time: float = Time.get_ticks_msec() / 1000.0
	var total_ticks: float = floor(poison_component.duration)
	for i in total_ticks:
		health_container.damage(damage_per_second)
		#print("Did one tick of damage! Current Health = ", health_container.get_health())
		await get_tree().create_timer(1.0).timeout
	is_poisoned = false

func resolve_knockback(hit_box):
	if (motion_controller != null):
		motion_controller.apply_impulse((global_position - hit_box.global_position).normalized() 
		* knockback_component.knockback * (1-(knockback_resistance / 100)))
