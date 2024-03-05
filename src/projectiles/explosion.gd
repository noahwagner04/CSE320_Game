extends Projectile

var explosion_lifetime: float = 0.2

func _ready():
	projectile_damage = 20
	knockback = 0
	$HitBox.set_basic_attributes(projectile_damage, knockback)
	await get_tree().create_timer(explosion_lifetime).timeout
	queue_free()
