extends Node2D

@export var enabled: bool = false 

@export var attack_speed: float = 0.5
@export var projectile_damage: int = 10
@export var projectile_speed: int = 200
@export_range(5, 500, 1) var projectile_range: int = 50
@export_enum("line", "swing") var projectile_type: String = "line"
@export_range(0, 10, 1) var chain_reactions: int = 0
var time_of_last_attack: float = 0.0


func _ready():
	set_process(enabled)
	$ProjectileSpawner.projectile_damage = projectile_damage
	$ProjectileSpawner.projectile_range = projectile_range
	$ProjectileSpawner.projectile_type = projectile_type
	$ProjectileSpawner.projectile_speed = projectile_speed
	$ProjectileSpawner.chain_reactions = chain_reactions
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("basic_attack"):
		basic_attack()

func basic_attack():
	var current_time = Time.get_ticks_msec() / 1000.0

	if current_time - time_of_last_attack < attack_speed:
		return
	time_of_last_attack = current_time
	var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	$ProjectileSpawner.spawn_projectile(direction)
