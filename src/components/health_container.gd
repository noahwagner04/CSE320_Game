class_name HealthContainer 
extends Node

# potentially make health_changed only emit when (health - old_health != 0)
signal health_changed(amount)
signal health_depleted

@export var max_health: float = 100

var health: float
var is_dead: bool = false


func _ready():
	health = max_health


func damage(amount):
	var old_health = health
	health = clamp(health - amount, 0, max_health)
	emit_signal("health_changed", health - old_health)


func heal(amount):
	var old_health = health
	health = clamp(health + amount, 0, max_health)
	emit_signal("health_changed", health - old_health)


func _on_health_changed(_amount):
	if is_zero_approx(health) and not is_dead:
		emit_signal("health_depleted")
		is_dead = true
