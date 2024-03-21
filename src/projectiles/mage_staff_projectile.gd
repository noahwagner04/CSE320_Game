extends Projectile

var explosion: PackedScene = preload("res://src/projectiles/explosion.tscn")

func explode():
	if aoe_explosion == true:
		var explosion_instance = explosion.instantiate()
		add_child(explosion_instance)

func _on_hit_box_area_entered(_area):
	explode()
