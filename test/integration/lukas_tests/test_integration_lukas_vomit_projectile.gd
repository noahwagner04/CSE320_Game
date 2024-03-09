extends GutTest

var behemoth_vole: CharacterBody2D
var health_container: HealthContainer
var vomit_projectile: Node2D
var player: CharacterBody2D
var skeleton: Node


# Bottom-up Integration
func before_each():
	player = preload("res://src/player/player.tscn").instantiate()
	add_child_autofree(player)
	player.add_to_group("player")
	
	behemoth_vole = preload("res://src/enemies/boss_behemoth_vole.tscn").instantiate()
	add_child_autofree(behemoth_vole)
	health_container = $behemoth_vole_boss/HealthContainer
	
	vomit_projectile = preload("res://src/projectiles/vomit_projectile.tscn").instantiate()
	add_child_autofree(vomit_projectile)


# Bottom-up integration
#func test_spawn_skeleton_from_puddle():
	#vomit_projectile.global_position = Vector2(15,15)
	#await vomit_projectile._ready()
	#print(get_child_count())
	#print(get_children())
	#skeleton = get_node("./swallowed_man")
	#print(skeleton.global_position)
	#assert_almost_eq(skeleton.global_position, vomit_projectile.global_position, Vector2(2,2), 'Skeleton must spawn around middle of puddle')
	#assert_true(vomit_projectile.projectile_speed == 0)
	
	
#func test_boss_minion_spawn():
	#behemoth_vole.global_position = Vector2(20,20)
	#var children: Array[Node] = get_children()
	#await behemoth_vole.summon_voles(2)
	#var giant_vole: CharacterBody2D = children.filter(func(obj): return obj is CharacterBody2D)[2]
	#assert_eq(children, 2 * 8)
	#var about_distance = get_node("giant_vole").to_global(get_node("giant_vole").position)
	#assert_almost_eq(about_distance, behemoth_vole.global_distance, 5, 'giant voles should spawn close to boss')
