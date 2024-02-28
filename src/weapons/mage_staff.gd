extends Weapon

@export var enabled: bool = false 
@export var item_special_duration: float = 5.0
var aoe_explosion: bool = false

@onready var projectile_spawner = $ProjectileSpawner


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
	projectile_spawner.set_universal_projectile_attributes(projectile_damage, 
		projectile_speed, projectile_range, projectile_type)
	projectile_spawner.projectile_aoe_explosion = aoe_explosion


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
