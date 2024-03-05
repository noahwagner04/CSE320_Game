extends GutTest

var test_player: CharacterBody2D
var far: CharacterBody2D = CharacterBody2D.new()
var close: CharacterBody2D = CharacterBody2D.new()
var main_scene: Node2D
var collider_test: Area2D

func before_all():
	main_scene = preload("res://src/main.tscn").instantiate()
	main_scene.name = "Main"
	GameManager.players[1] = {"name": "test_player", "id": 1}
	get_node("/root").add_child(main_scene)
	test_player = preload("res://src/player/player.tscn").instantiate()
	test_player.name = "1"
		
	add_child_autofree(test_player)
	
	collider_test = preload("res://src/components/collider_detector.tscn").instantiate()
	far.global_position = Vector2(20,20)
	close.global_position = Vector2(2,2)
	collider_test.intersecting_colliders.append(far)
	collider_test.intersecting_colliders.append(close)

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
	var closets_collider = collider_test.get_closest_collider()
	assert_eq(closets_collider, close, "closest collision object is 'close' ")





