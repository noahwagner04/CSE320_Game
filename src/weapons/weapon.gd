extends Node2D
class_name Weapon

@export var attack_speed: float = 1.0
@export var projectile_damage: float = 10
@export var projectile_speed: float = 300
@export_range(5, 500, 1) var projectile_range: float = 500
@export_enum("line", "swing") var projectile_type: String = "line"
@export var knockback: float = 0
var time_of_last_attack: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func grab_all_stats():
	pass
