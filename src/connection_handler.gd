extends Node

var address = "127.0.0.1"
var port = 8910
var peer

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

# gets called on both servers and clients
func peer_connected(id):
	print("Player connected " + str(id))
	
# gets called on both servers and clients
func peer_disconnected(id):
	print("Player disconnected " + str(id))
	GameManager.delete_player(id)
	
# gets called only on clients
func connected_to_server():
	print("connected to server")
	sync_player_join.rpc_id(1, GameManager.player_name, multiplayer.get_unique_id())

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
	
	sync_player_join(GameManager.player_name, multiplayer.get_unique_id())
	
	print("Waiting for players...")
	
func set_peer_client():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	
@rpc("any_peer")
func sync_player_join(pname, id):
	# add given player to player dictionary if entry doesn't exist
	if !GameManager.players.has(id):
		GameManager.players[id] = {
			"name": pname,
			"id": id,
		}
		
		GameManager.instantiate_player(id)
		
	
	# if we're the server, tell all other players a new player joined
	if multiplayer.is_server():
		# rpc to all players to send the new player all other players
		for i in GameManager.players:
			sync_player_join.rpc(GameManager.players[i].name, i)
			

