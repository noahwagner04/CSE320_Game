class_name HurtBox 
extends Area2D

signal hurt(hit_box)

@export var health_container: HealthContainer


func _on_area_entered(area):
	if not (area is HitBox):
		return
	if health_container != null:
		health_container.damage(area.damage)
	emit_signal("hurt", area)
