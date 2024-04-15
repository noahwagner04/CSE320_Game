extends Projectile

var explosion_lifetime: float = 0.2

func _ready():
	$HitBox.set_damage(projectile_damage)
	await get_tree().create_timer(explosion_lifetime).timeout
	queue_free()
