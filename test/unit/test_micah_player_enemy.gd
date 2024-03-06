extends GutTest

var test_player: CharacterBody2D
var test_enemy: CharacterBody2D
var main_scene: Node2D
var invalid_name_test: CharacterBody2D = CharacterBody2D.new()
var far: CharacterBody2D = CharacterBody2D.new()
var close: CharacterBody2D = CharacterBody2D.new()
var collider_test: Area2D

func before_all():
	main_scene = preload("res://test/scenes/player_enemy_testscene.tscn").instantiate()
	main_scene.name = "Main"
	get_node("/root").add_child(main_scene)
	ConnectionHandler.set_peer_host()
	test_player = get_tree().get_nodes_in_group("player")[0]
	
	collider_test = preload("res://src/components/collider_detector.tscn").instantiate()
	far.global_position = Vector2(20,20)
	close.global_position = Vector2(2,2)
	invalid_name_test.name = "invalid"
	collider_test.filter_func = func (obj: CollisionObject2D): return obj.name != "invalid" 
	collider_test.intersecting_colliders.append(far)
	collider_test.intersecting_colliders.append(close)


func before_each():
	test_enemy = preload("res://src/enemies/giant_vole.tscn").instantiate()
	test_enemy.global_position = Vector2(2000, 2000)
	add_child_autofree(test_enemy)


#Integration testing, Big Bang Approach (testing the player and enemy objects)
func test_enemy_agro():
	test_enemy.global_position = Vector2(100, 100)
	await get_tree().process_frame
	assert_eq(test_enemy._target, test_player, "when the player is in agro range of enemy, the enemies target is the player")


#Integration testing, Big Bang Approach (testing the player and enemy objects)
func test_enemy_attack():
	test_enemy.global_position = Vector2(10, 10)
	await get_tree().create_timer(0.5).timeout
	assert_lt(test_player.health_container.health, 100, "player must be damaged when enemy intersects its collision box")


#acceptance test
func test_authoritative_player_movement():
	Input.action_press("move_up")
	await get_tree().create_timer(0.1).timeout
	Input.action_release("move_up")
	assert_lt(test_player.global_position.y, 0, "when we press the up key, the player should move")


#Integration testing, Big Bang Approach (testing the player and enemy objects)
func test_player_attack():
	test_enemy.global_position = Vector2(0, 0)
	Input.action_press("basic_attack")
	await get_tree().create_timer(0.5).timeout
	Input.action_release("basic_attack")
	var enemy_health = test_enemy.get_children().filter(func (child): return child is HealthContainer)[0]
	assert_lt(enemy_health.health, enemy_health.max_health, "when we press the up key, the player should move")


#acceptance test
func test_closest_collider():
	var closet_collider = collider_test.get_closest_collider()
	assert_eq(closet_collider, close, "closest collision object is 'close' ")


#acceptance test
func test_invalid_add_collision():
	collider_test.add_collision_object(invalid_name_test)
	assert_eq(collider_test.intersecting_colliders.has(invalid_name_test), false, "colliders array must not contain entries filtered by the specified filter function")
