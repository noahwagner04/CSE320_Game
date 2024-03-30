extends Node

var PORT = 8080

func _ready():
	pass
	
func _on_host_pressed():
	print("host pressed")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	start_game()
	
func start_game():
	$UI.hide()
	if multiplayer.is_server():
		change_level.call_deferred(load("res://src/main.tscn"))


func change_level(scene: PackedScene):
	var level = $Level
	
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	
	level.add_child(scene.instantiate())


func _on_client_pressed():
	print("client pressed")
	var ip = "127.0.0.1"
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer
	start_game()


