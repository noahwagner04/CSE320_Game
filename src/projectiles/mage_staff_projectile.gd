extends Projectile

var explosion: PackedScene = preload("res://src/projectiles/explosion.tscn")

func explode():
	if aoe_explosion == true:
		var explosion_instance = explosion.instantiate()
		call_deferred("add_child", explosion_instance)
		explosion_instance.set_deferred("projectile_damage", 3 * projectile_damage)
		
func _on_hit_box_area_entered(_area):
	explode()
