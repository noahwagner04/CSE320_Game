extends GutTest

var main_scene: Node2D
var test_player: CharacterBody2D

func before_all():
	main_scene = preload("res://test/scenes/player_enemy_testscene.tscn").instantiate()
	main_scene.name = "Main"
	get_node("/root").add_child(main_scene)


func before_each():
	var scene_players = get_tree().get_nodes_in_group("player")
	
	for i in scene_players:
		i.queue_free()
		
	GameManager.players[1] = {"name": "test_player", "id": 1}
	test_player = preload("res://src/player/player.tscn").instantiate()
	test_player.name = "1"
	add_child_autofree(test_player)
	


#acceptance test
func test_spawn_new_player():
	GameManager.instantiate_player(2)
	var scene_players = get_tree().get_nodes_in_group("player")
	for i in scene_players:
		if i.name == "2":
			assert_true(true, "player in scene with the name equal to its id")
			return
	assert_false(true, "player should spawn in scene with the name equal to its id")


#acceptance test
func test_spawn_existing_player():
	GameManager.instantiate_player(1)
	assert_eq(GameManager.players[1].name, "test_player", "spawning a player with the same id should not be possible")
	print(get_tree().get_nodes_in_group("player"))


#acceptance test
func test_delete_existing_player():
	GameManager.delete_player(1)
	await get_tree().process_frame
	var scene_players = get_tree().get_nodes_in_group("player")
	for i in scene_players:
		if i.name == "1":
			assert_false(true, "player should not exist in scene after deleting")
			return
	assert_true(true, "player does not exist in scene tree")

