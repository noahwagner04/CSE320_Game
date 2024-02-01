extends Node

var players = {}
var address = "127.0.0.1"
var port = 8910
var peer

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)


func _process(delta):
	pass

# gets called on both servers and clients
func peer_connected(id):
	print("Player connected " + str(id))
	
# gets called on both servers and clients
func peer_disconnected(id):
	print("Player disconnected " + str(id))
	
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
	
func set_peer_client():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
