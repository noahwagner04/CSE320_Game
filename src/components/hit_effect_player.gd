extends Node2D

@export var health_container: HealthContainer
@export var sprite: Sprite2D
@export var length: float = 0.15
@export var transition: float = 3
@export_range(0, 1, 0.01) var compression: float = 0.6

var _flash_material = preload("res://assets/materials/flash_material.tres")

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var spawner: Spawner = %Spawner

func _ready():
	health_container.health_changed.connect(_on_hit)
	
	animation_player.root_node = sprite.get_parent().get_path()
	
	sprite.material = _flash_material.duplicate()
	
	var animation = Animation.new()
	
	var relative_sprite_path = str(get_node(animation_player.root_node).get_path_to(sprite))
	
	var opacity_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(opacity_index, relative_sprite_path + ":material:shader_parameter/opacity")
	animation.track_insert_key(opacity_index, 0.0, 1, transition)
	animation.track_insert_key(opacity_index, length, 0)
	
	var size_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(size_index, relative_sprite_path + ":scale")
	var sprite_scale = sprite.scale
	animation.track_insert_key(size_index, 0.0, Vector2(sprite_scale.x * compression, sprite_scale.y), transition)
	animation.track_insert_key(size_index, length, sprite_scale)
	
	animation.length = length
	
	var animation_library = AnimationLibrary.new()
	animation_library.add_animation("hit", animation)
	animation_player.add_animation_library("", animation_library)


func play():
	animation_player.play("hit")


func spawn_hit_text(damage):
	var text: Node2D = spawner.instantiate()
	if text == null:
		return
	text.damage = floor(damage * 100) / 100
	spawner.add_to_tree(text)


func _on_hit(amount):
	if amount >= 0:
		return
	play()
	spawn_hit_text(amount)
