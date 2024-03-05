extends Weapon

var item_special_duration: float = 5.0
var aoe_explosion: bool = false


func _ready():
	
	base_attack_speed = 1.0
	base_projectile_damage = 10
	projectile_speed = 300
	projectile_range = 500
	projectile_type = "line"
	aoe_explosion = false
	dex_ratio = 0.1
	atk_ratio = 1.0
	set_base_values()
	set_rarity_bonuses()
	set_stat_bonuses()
	
	projectile_spawner.set_universal_projectile_attributes(projectile_damage, 
		projectile_speed, projectile_range, projectile_type)
	projectile_spawner.projectile_aoe_explosion = aoe_explosion


func basic_attack():
	var current_time = Time.get_ticks_msec() / 1000.0

	if (current_time - time_of_last_attack) < 1/attack_speed:
		return
	time_of_last_attack = current_time
	var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	projectile_spawner.spawn_projectile(direction)


func item_special():
	if aoe_explosion == true:
		return
	# subtract mana
	aoe_explosion = true;
	projectile_spawner.projectile_aoe_explosion = aoe_explosion
	print("aoe on!")
	await get_tree().create_timer(item_special_duration).timeout
	aoe_explosion = false;
	projectile_spawner.projectile_aoe_explosion = aoe_explosion
	print("aoe off!")
