extends Area2D

class_name HurtBox

signal hurt(hit_box)

func _on_area_entered(area):
	if area is HitBox:
		emit_signal("hurt", area)
