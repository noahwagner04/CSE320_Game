extends AnimationPlayer

@export var sprite: Sprite2D
@export var length: float = 0.15
@export var transition: float = 3
@export_range(0, 1, 0.01) var compression: float = 0.6

var _flash_material = preload("res://assets/materials/flash_material.tres")

func _ready():
	if not sprite is Sprite2D:
		return
	
	sprite.material = _flash_material.duplicate()
	
	# create both flash and squash animations from sprite
	var animation = Animation.new()
	
	var relative_sprite_path = str(get_node(root_node).get_path_to(sprite))
	
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
	add_animation_library("", animation_library)
