extends Node

var players = {}
var player_name: String

signal new_player_created(player: CharacterBody2D)

func instantiate_player(id):
	players[id] = {
		"name": player_name,
		"id": id,
	}
	
	var new_player = preload("res://src/player/player.tscn").instantiate()
	new_player.name = str(id)
	new_player.global_position = Vector2.ZERO
	get_node("/root/Startup/Level/Main").add_child(new_player)
	new_player_created.emit(new_player)

