extends Node

var address := "127.0.0.1"
var port: int = 8910
var peer: ENetMultiplayerPeer


func _ready():
	if multiplayer.is_server():
		multiplayer.peer_connected.connect(peer_connected)
		multiplayer.peer_disconnected.connect(peer_disconnected)
		
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)


# gets called on both servers and clients
func peer_connected(id):
	print("Player connected " + str(id))
	GameManager.instantiate_player(id)


# gets called on both servers and clients
func peer_disconnected(id):
	print("Player disconnected " + str(id))
	GameManager.delete_player(id)


# gets called only on clients
func connected_to_server():
	print("connected to server")


#gets called only on clients
func connection_failed():
	print("connection to server failed")


func set_peer_host():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 32)
	if error != OK:
		print("cannot host" + str(error))
		return
		
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players...")
			
	if not OS.has_feature("dedicated_server"):
		GameManager.instantiate_player(1)


func set_peer_client():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

