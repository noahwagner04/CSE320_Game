extends Node2D


func _ready():
	# since we change scenes, we must instantiate our server player here
	# clients dont need this since we have a connected callback
	if (multiplayer.is_server()):
		ConnectionManager.sync_player_join(ConnectionManager.player_name, multiplayer.get_unique_id())
		
	await get_tree().create_timer(5).timeout
	print(ConnectionManager.players)




func _process(delta):
	pass
