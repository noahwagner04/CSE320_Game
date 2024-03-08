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
	

# White box
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
