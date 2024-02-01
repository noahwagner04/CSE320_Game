class_name HurtBox extends Area2D

@export var health_container: HealthContainer

signal hurt(hit_box)

func _on_area_entered(area):
	if not (area is HitBox):
		return
	if health_container != null:
		health_container.damage(area.damage)
	emit_signal("hurt", area)
