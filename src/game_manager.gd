extends Node

var players = {}
var player_name: String

signal new_player_created(player: CharacterBody2D)

func instantiate_player(id):
	var new_player = preload("res://src/player/player.tscn").instantiate()
	new_player.name = str(id)
	new_player.global_position = Vector2(cos(randf()), sin(randf())) * 100
	get_node("/root").add_child(new_player)
	new_player_created.emit(new_player)

func delete_player(id):
	players.erase(id)
	var scene_players = get_tree().get_nodes_in_group("player")
	for i in scene_players:
		if i.name == str(id):
			i.queue_free()
