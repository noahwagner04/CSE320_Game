class_name HurtBox 
extends Area2D

signal hurt(hit_box)

@export var health_container: HealthContainer
@onready var poison_component: Node = $PoisonComponent


func _on_area_entered(area):
	if not (area is HitBox):
		return
	if health_container != null:
		health_container.damage(area.damage)
		
	#emit_signal("hurt", area)
	#return
		
	#effects
	if area.poison_component.effect_active == true:
		poison_component.effect_active = true
		poison_component.percent_of_max_health_per_second = area.PoisonComponent.percent_of_max_health_per_second
		poison_component.duration = area.PoisonComponent.duration
		resolve_poison()
	
	emit_signal("hurt", area)

func resolve_poison():
	if health_container == null:
		return
	var damage_per_second: float = health_container.max_health * poison_component.percent_of_max_health_per_second / 100.0
	var curr_time: float = Time.get_ticks_msec() / 1000.0
	var total_ticks: float = floor(poison_component.duration)
	for i in total_ticks:
		health_container.damage(damage_per_second)
		await get_tree().create_timer(1.0).timeout
