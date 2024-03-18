extends GutTest

var vomit_projectile: Node2D
var player: CharacterBody2D
var behemoth_vole: CharacterBody2D


func before_each():
	vomit_projectile = preload("res://src/projectiles/vomit_projectile.tscn").instantiate()
	player = preload("res://src/player/player.tscn").instantiate()
	behemoth_vole = preload("res://src/enemies/boss_behemoth_vole.tscn").instantiate()
	add_child_autofree(player)
	player.add_to_group("player")
	add_child_autofree(behemoth_vole)
	add_child_autofree(vomit_projectile)
	

# White-box with function coverage
#func _ready():
	#if (player == null):
		#return
	#global_position = behemoth_vole_position# + start_velocity
	#$HitBox.set_poison(poison_component.effect_active, poison_component.percent_of_max_health_per_second, poison_component.duration)
	#projectile_direction = to_local(player.global_position).normalized()
	#projectile_lifetime = projectile_range / projectile_speed
	#await get_tree().create_timer(projectile_lifetime).timeout
	#sprite.texture = puddle_sprite
	#sprite.scale = Vector2(2,2)
	#projectile_speed = 0
	#start_velocity = Vector2(0,0)
	#top_level = false
	#z_index = 0
	#
	#var swallowed_man_instance: Node = swallowed_man_scene.instantiate()
	#call_deferred("add_sibling", swallowed_man_instance, false)
	#swallowed_man_instance.global_position = global_position
	#
	#await get_tree().create_timer(30).timeout
	#queue_free()
#
#
#func _process(delta):
	#global_position += projectile_direction * delta * projectile_speed + start_velocity/64
	
func test_instantiation():
	assert_almost_eq(vomit_projectile.global_position, behemoth_vole.global_position, Vector2(2, 2), 'Must be near the center of the boss on instantiation')
	assert_true(vomit_projectile.projectile_direction.is_normalized())
	assert_true(vomit_projectile.projectile_lifetime > 0)
	
	
func test_process():
	vomit_projectile.global_position = Vector2(1,1)
	vomit_projectile.projectile_direction = Vector2(1,1)
	vomit_projectile.projectile_speed = 5
	vomit_projectile.start_velocity = Vector2(128,128)
	vomit_projectile._process(2)
	assert_eq(vomit_projectile.global_position, Vector2(13,13))
