extends Shortbow


# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_rarity = 6
	special_angle = 350
	num_special_bolts = 35
	set_base_values()
	set_rarity_bonuses()
	set_stat_bonuses()
	num_special_bolts = num_special_bolts-1
	angle_per_bolt = special_angle/(num_special_bolts)
	projectile_spawner.set_universal_projectile_attributes(projectile_damage, 
		projectile_speed, projectile_range, projectile_type)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
