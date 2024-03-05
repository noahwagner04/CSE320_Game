extends Node2D

@export var projectile_speed: float = 70
@export_range(5, 500, 1) var projectile_range: float = 150
@onready var sprite: Sprite2D = $Sprite2D
@onready var puddle_sprite: CompressedTexture2D = preload("res://assets/effects/vomit_puddle.png")
@onready var start_velocity: Vector2 = get_node("../behemoth_vole_boss").velocity
@onready var behemoth_vole_position: Vector2 = get_node("../behemoth_vole_boss").global_position
@onready var player: Node = get_tree().get_first_node_in_group("player")
@onready var swallowed_man_scene: PackedScene = preload("res://src/enemies/swallowed_man.tscn")
@onready var poison_component = $PoisonComponent

var projectile_direction: Vector2 


func _ready():
	if (player == null):
		return
	global_position = behemoth_vole_position# + start_velocity
	$HitBox.set_poison(poison_component.effect_active, poison_component.percent_of_max_health_per_second, poison_component.duration)
	projectile_direction = to_local(player.global_position).normalized()
	var projectile_lifetime = projectile_range / projectile_speed
	await get_tree().create_timer(projectile_lifetime).timeout
	sprite.texture = puddle_sprite
	sprite.scale = Vector2(2,2)
	projectile_speed = 0
	start_velocity = Vector2(0,0)
	top_level = false
	z_index = 0
	
	var swallowed_man_instance: Node = swallowed_man_scene.instantiate()
	call_deferred("add_sibling", swallowed_man_instance, false)
	swallowed_man_instance.global_position = global_position
	
	await get_tree().create_timer(30).timeout
	queue_free()


func _process(delta):
	global_position += projectile_direction * delta * projectile_speed + start_velocity/64
