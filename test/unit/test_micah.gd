extends GutTest

var test_player: CharacterBody2D
var test_enemy: CharacterBody2D
var far: CharacterBody2D = CharacterBody2D.new()
var close: CharacterBody2D = CharacterBody2D.new()
var invalid_name_test: CharacterBody2D = CharacterBody2D.new()
var main_scene: Node2D
var connection_scene: Control
var collider_test: Area2D

func before_all():
	main_scene = preload("res://test/scenes/player_enemy_testscene.tscn").instantiate()
	main_scene.name = "Main"
	get_node("/root").add_child(main_scene)
	
	connection_scene = get_node("/root/Main/ConnectionScene")
	
	
	
	collider_test = preload("res://src/components/collider_detector.tscn").instantiate()
	far.global_position = Vector2(20,20)
	close.global_position = Vector2(2,2)
	invalid_name_test.name = "invalid"
	collider_test.filter_func = func (obj: CollisionObject2D): return obj.name != "invalid" 
	collider_test.intersecting_colliders.append(far)
	collider_test.intersecting_colliders.append(close)


func before_each():
	var scene_players = get_tree().get_nodes_in_group("player")
	
	for i in scene_players:
		i.queue_free()
		
	GameManager.players[1] = {"name": "test_player", "id": 1}
	test_player = preload("res://src/player/player.tscn").instantiate()
	test_player.name = "1"
	add_child_autofree(test_player)
	
	test_enemy = preload("res://src/enemies/giant_vole.tscn").instantiate()
	test_enemy.global_position = Vector2(2000, 2000)
	add_child_autofree(test_enemy)


func test_spawn_new_player():
	GameManager.instantiate_player(2)
	var scene_players = get_tree().get_nodes_in_group("player")
	for i in scene_players:
		if i.name == "2":
			assert_true(true, "player in scene with the name equal to its id")
			return
	assert_false(true, "player should spawn in scene with the name equal to its id")


func test_spawn_existing_player():
	GameManager.instantiate_player(1)
	assert_eq(GameManager.players[1].name, "test_player", "spawning a player with the same id should not be possible")
	print(get_tree().get_nodes_in_group("player"))


func test_delete_existing_player():
	GameManager.delete_player(1)
	await get_tree().process_frame
	var scene_players = get_tree().get_nodes_in_group("player")
	for i in scene_players:
		if i.name == "1":
			assert_false(true, "player should not exist in scene after deleting")
			return
	assert_true(true, "player does not exist in scene tree")


func test_closest_collider():
	var closet_collider = collider_test.get_closest_collider()
	assert_eq(closet_collider, close, "closest collision object is 'close' ")


func test_invalid_add_collision():
	collider_test.add_collision_object(invalid_name_test)
	assert_eq(collider_test.intersecting_colliders.has(invalid_name_test), false, "colliders array must not contain entries filtered by the specified filter function")


func test_join_botton():
	connection_scene._on_join_button_pressed()
	assert_not_same(multiplayer.get_unique_id(), 1, "when pressing join, peer object should be instantiated and not set to 1 (1 means server)")


func test_host_botton():
	connection_scene._on_host_button_pressed()
	assert_eq(multiplayer.is_server(), true, "pressing host sets the peer object to server")


#maybe? make better
func test_hosting_error():
	ConnectionHandler.set_peer_host()
	connection_scene._on_host_button_pressed()
	assert_eq(multiplayer.is_server(), true, "pressing host when already hosting should not change the peer object")


func test_enemy_agro():
	ConnectionHandler.set_peer_host()
	test_enemy.global_position = Vector2(100, 100)
	await get_tree().process_frame
	assert_eq(test_enemy._target, test_player, "when the player is in agro range of enemy, the enemies target is the player")


func test_enemy_attack():
	test_enemy.global_position = Vector2(10, 10)
	await get_tree().create_timer(0.5).timeout
	assert_lt(test_player.health_bar.value, 100, "player must be damaged when enemy intersects its collision box")


func test_authoritative_player_movement():
	ConnectionHandler.set_peer_host()
	Input.action_press("move_up")
	await get_tree().create_timer(0.1).timeout
	Input.action_release("move_up")
	assert_lt(test_player.global_position.y, 0, "when we press the up key, the player should move")


func test_player_attack():
	test_enemy.global_position = Vector2(0, 0)
	Input.action_press("basic_attack")
	await get_tree().create_timer(0.5).timeout
	Input.action_release("basic_attack")
	assert_lt(test_enemy.health_container.health, test_enemy.health_container.max_health, "when we press the up key, the player should move")
