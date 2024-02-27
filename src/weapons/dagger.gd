extends Node2D

@export var enabled: bool = false 

@export var attack_speed: float = 4.0
@export var projectile_damage: float = 6
@export var projectile_speed: float = 500
@export_range(5, 500, 1) var projectile_range: float = 50
@export_enum("line", "swing") var projectile_type: String = "line"
@export var knockback: float = 175
var time_of_last_attack: float = 0.0
var time_of_last_special: float = 0.0
var special_delay: float = 0.3
var special_projectile_damage: float = 24
var special_projectile_range: float = 300
var special_projectile_knockback: float = 0

# player_stats contains all player stat variables
@onready var player_stats = $"../PlayerStats"

func _ready():
	
	# Setting dagger attack speed and damage scaling
	attack_speed = float(player_stats.dexterity * 0.4)
	projectile_damage = float(player_stats.attack * 0.6)
	
	set_process(enabled)
	$ProjectileSpawner.set_universal_projectile_attributes(projectile_damage, 
		projectile_speed, projectile_range, projectile_type)
	$ProjectileSpawner.projectile_knockback = knockback
	$ProjectileSpawner.set_poison_projectile_attributes($PoisonComponent.effect_active,
		$PoisonComponent.percent_of_max_health_per_second, $PoisonComponent.duration)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("basic_attack"):
		basic_attack()
	if Input.is_action_pressed("item_special"):
		item_special()

func basic_attack():
	var current_time = Time.get_ticks_msec() / 1000.0

	if (current_time - time_of_last_attack) < 1/attack_speed:
		return
	time_of_last_attack = current_time
	var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	$ProjectileSpawner.spawn_melee_projectile(direction)

func item_special():
	var current_time = Time.get_ticks_msec() / 1000.0
	if (current_time - time_of_last_special) < special_delay:
		return
	# subtract 30 mana
	time_of_last_special = current_time
	$ProjectileSpawner.projectile_damage = special_projectile_damage
	$ProjectileSpawner.projectile_range = special_projectile_range
	$ProjectileSpawner.projectile_knockback = special_projectile_knockback
	var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	$ProjectileSpawner.spawn_projectile(direction)
	$ProjectileSpawner.projectile_damage = projectile_damage
	$ProjectileSpawner.projectile_range = projectile_range
	$ProjectileSpawner.projectile_knockback = knockback
	
