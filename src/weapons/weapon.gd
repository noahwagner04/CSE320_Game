extends Node2D
class_name Weapon

@export_range(1, 6, 1) var weapon_rarity: int = 1
@export var base_attack_speed: float = 1.0
@export var base_projectile_damage: float = 10
var attack_speed: float = 1.0
var projectile_damage: float = 10
@export var projectile_speed: float = 300
@export_range(5, 500, 1) var projectile_range: float = 500
@export_enum("line", "swing") var projectile_type: String = "line"
@export var knockback: float = 0
@onready var player_stats = $"../PlayerStats"
@onready var projectile_spawner = $ProjectileSpawner
var time_of_last_attack: float = 0.0
var rarity_ratio: float = weapon_rarity * 0.2 + 1
@export var dex_ratio: float = 0.4
@export var atk_ratio: float = 0.6

func _ready():
	pass

func set_base_values():
	attack_speed = base_attack_speed
	projectile_damage = base_projectile_damage
	
func set_rarity_bonuses():
	attack_speed *= rarity_ratio
	projectile_damage *= rarity_ratio
	
func set_stat_bonuses():
	attack_speed = float(player_stats.dexterity * dex_ratio)
	projectile_damage = float(player_stats.attack * atk_ratio)

func basic_attack():
	pass
	
func item_special():
	pass
