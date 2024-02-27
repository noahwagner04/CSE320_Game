class_name HealthContainer 
extends Node

signal health_changed(amount)
signal health_depleted

@export var max_health: float = 100

var _health: float


func _ready():
	if $"../".has_node("PlayerStats"):
		max_health = $"../PlayerStats".health
	_health = max_health


func get_health():
	return _health


func damage(amount):
	if is_zero_approx(_health):
		return
	var old_health = _health
	_health = maxf(_health - amount, 0)
	emit_signal("health_changed", _health - old_health)


func heal(amount):
	if is_equal_approx(_health, max_health):
		return
	var old_health = _health
	_health = minf(_health + amount, max_health)
	emit_signal("health_changed", _health - old_health)


func _on_health_changed(_amount):
	if is_zero_approx(_health):
		emit_signal("health_depleted")
