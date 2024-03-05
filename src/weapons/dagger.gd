extends Weapon

var time_of_last_special: float = 0.0
var special_delay: float = 0.3
var special_projectile_damage: float = 24
var special_projectile_range: float = 300
var special_projectile_knockback: float = 0

@onready var poison_component = $PoisonComponent

func _ready():
	base_attack_speed = 4.0
	base_projectile_damage = 6
	projectile_speed = 500
	projectile_range = 50
	projectile_type = "line"
	knockback = 175
	dex_ratio = 0.4
	atk_ratio = 0.6
	set_base_values()
	set_rarity_bonuses()
	set_stat_bonuses()
	
	projectile_spawner.set_universal_projectile_attributes(projectile_damage, 
		projectile_speed, projectile_range, projectile_type)
	projectile_spawner.projectile_knockback = knockback
	projectile_spawner.set_poison_projectile_attributes(poison_component.effect_active,
		poison_component.percent_of_max_health_per_second, poison_component.duration)

func basic_attack():
	var current_time = Time.get_ticks_msec() / 1000.0

	if (current_time - time_of_last_attack) < 1/attack_speed:
		return
	time_of_last_attack = current_time
	var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	projectile_spawner.spawn_melee_projectile(direction)

func item_special():
	var current_time = Time.get_ticks_msec() / 1000.0
	if (current_time - time_of_last_special) < special_delay:
		return
	# subtract 30 mana
	time_of_last_special = current_time
	projectile_spawner.projectile_damage = special_projectile_damage
	projectile_spawner.projectile_range = special_projectile_range
	projectile_spawner.projectile_knockback = special_projectile_knockback
	var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	projectile_spawner.spawn_projectile(direction)
	projectile_spawner.projectile_damage = projectile_damage
	projectile_spawner.projectile_range = projectile_range
	projectile_spawner.projectile_knockback = knockback
	
