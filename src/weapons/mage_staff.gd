extends Node2D

@export var enabled: bool = false 
@export var attack_speed: float = 1.0
@export var projectile_damage: float = 10
@export var projectile_speed: float = 300
@export var item_special_duration: float = 5.0
@export_range(5, 500, 1) var projectile_range: float = 500
@export_enum("line", "swing") var projectile_type: String = "line"
var aoe_explosion: bool = false
@export var knockback: float = 0
var time_of_last_attack: float = 0.0


func _ready():
	set_process(enabled)
	$ProjectileSpawner.projectile_damage = projectile_damage
	$ProjectileSpawner.projectile_range = projectile_range
	$ProjectileSpawner.projectile_type = projectile_type
	$ProjectileSpawner.projectile_speed = projectile_speed
	$ProjectileSpawner.aoe_explosion = aoe_explosion


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
	$ProjectileSpawner.spawn_projectile(direction)


func item_special():
	if aoe_explosion == true:
		return
	# subtract mana
	aoe_explosion = true;
	$ProjectileSpawner.aoe_explosion = aoe_explosion
	print("aoe on!")
	await get_tree().create_timer(item_special_duration).timeout
	aoe_explosion = false;
	$ProjectileSpawner.aoe_explosion = aoe_explosion
	print("aoe off!")
