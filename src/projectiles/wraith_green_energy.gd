extends Projectile


# Called when the node enters the scene tree for the first time.
func _ready():
	$HitBox.set_damage(projectile_damage)
	var projectile_lifetime: float = projectile_range / projectile_speed
	await get_tree().create_timer(projectile_lifetime).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += projectile_direction * delta * projectile_speed
