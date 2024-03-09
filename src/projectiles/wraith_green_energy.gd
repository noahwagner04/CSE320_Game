extends Node2D


var projectile_direction: Vector2
var projectile_speed: float
var projectile_damage: float 
var projectile_range: float
var projectile_type: String
var aoe_explosion: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	$HitBox.set_damage(projectile_damage)
	var projectile_lifetime: float = projectile_range / projectile_speed
	await get_tree().create_timer(projectile_lifetime).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += projectile_direction * delta * projectile_speed
