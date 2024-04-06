extends Weapon

var time_of_last_special = 0.0
var special_delay = 0.3

func _ready():
	set_base_values()
	set_rarity_bonuses()
	set_stat_bonuses()
	
	projectile_spawner.set_universal_projectile_attributes(projectile_damage, 
		projectile_speed, projectile_range, projectile_type)

func basic_attack():
	var current_time = Time.get_ticks_msec() / 1000.0

	if (current_time - time_of_last_attack) < 1/attack_speed:
		return
	time_of_last_attack = current_time
	var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	projectile_spawner.spawn_projectile(direction)
	
func item_special():
	# subtract mana
	var current_time = Time.get_ticks_msec() / 1000.0
	if (current_time - time_of_last_special) < special_delay:
		return
	time_of_last_special = current_time
	var dir: Vector2 = (get_global_mouse_position() - global_position).normalized().rotated(deg_to_rad(45))
	for ii in 7:
		print("poopy")
