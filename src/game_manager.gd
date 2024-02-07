extends Node

var players = {}
var player_name

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func instantiate_player(id):
	var new_player = preload("res://src/player/player.tscn").instantiate()
	new_player.name = str(id)
	new_player.global_position = Vector2(cos(randf()), sin(randf())) * 100
	get_node("/root").add_child(new_player)
	
func delete_player(id):
	players.erase(id)	
	var players = get_tree().get_nodes_in_group("player")
	for i in players:
		if i.name == str(id):
			i.queue_free()
