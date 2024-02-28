extends Weapon

@export var enabled: bool = false 
#@export var attack_speed: float = 1.0
#@export var projectile_damage: float = 10
#@export var projectile_speed: float = 300

#@export_range(5, 500, 1) var projectile_range: float = 500
#@export_enum("line", "swing") var projectile_type: String = "line"
@export var item_special_duration: float = 5.0
var aoe_explosion: bool = false
#@export var knockback: float = 0
#var time_of_last_attack: float = 0.0

# player_stats contains all player stat variables
@onready var player_stats = $"../PlayerStats"


func _ready():
	
	attack_speed = 1.0
	projectile_damage = 10
	projectile_speed = 300

	projectile_range = 500
	projectile_type = "line"
	aoe_explosion = false
	knockback = 0
	time_of_last_attack = 0.0
	
	# setting atk speed and dmg scaling
	attack_speed = float(player_stats.dexterity * 0.1)
	projectile_damage = float(player_stats.attack)
	
	set_process(enabled)
	$ProjectileSpawner.set_universal_projectile_attributes(projectile_damage, 
		projectile_speed, projectile_range, projectile_type)
	$ProjectileSpawner.projectile_aoe_explosion = aoe_explosion


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
	#if Input.is_action_pressed("basic_attack"):
		#basic_attack()
	#if Input.is_action_pressed("item_special"):
		#item_special()


func basic_attack():
	var current_time = Time.get_ticks_msec() / 1000.0

	if (current_time - time_of_last_attack) < 1/attack_speed:
		return
	time_of_last_attack = current_time
	var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	$ProjectileSpawner.spawn_projectile(direction)


func item_special():
	if aoe_explosion == true:
		return
	# subtract mana
	aoe_explosion = true;
	$ProjectileSpawner.projectile_aoe_explosion = aoe_explosion
	print("aoe on!")
	await get_tree().create_timer(item_special_duration).timeout
	aoe_explosion = false;
	$ProjectileSpawner.projectile_aoe_explosion = aoe_explosion
	print("aoe off!")
