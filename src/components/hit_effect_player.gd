extends AnimationPlayer

@export var sprite: Sprite2D

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
	animation.track_insert_key(opacity_index, 0.0, 1, 3)
	animation.track_insert_key(opacity_index, 0.15, 0)
	
	var size_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(size_index, relative_sprite_path + ":scale")
	var sprite_scale = sprite.scale
	animation.track_insert_key(size_index, 0.0, Vector2(sprite_scale.x * 0.6, sprite_scale.y), 3)
	animation.track_insert_key(size_index, 0.15, sprite_scale)
	
	animation.length = 0.15
	
	var animation_library = AnimationLibrary.new()
	animation_library.add_animation("hit", animation)
	add_animation_library("", animation_library)
