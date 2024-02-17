extends Node

var players = {}
var player_name: String


func instantiate_player(id):
	players[id] = {
		"name": player_name,
		"id": id,
	}
	
	var new_player = preload("res://src/player/player.tscn").instantiate()
	new_player.name = str(id)
	new_player.global_position = Vector2.ZERO
	get_node("/root/Main").add_child(new_player)


func delete_player(id):
	players.erase(id)
	var scene_players = get_tree().get_nodes_in_group("player")
	for i in scene_players:
		if i.name == str(id):
			i.queue_free()
