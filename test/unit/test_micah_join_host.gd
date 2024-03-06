extends GutTest

var main_scene: Node2D
var connection_scene: Control

func before_all():
	main_scene = preload("res://test/scenes/player_enemy_testscene.tscn").instantiate()
	main_scene.name = "Main"
	get_node("/root").add_child(main_scene)
	
	connection_scene = get_node("/root/Main/ConnectionScene")

func after_each():
	multiplayer.multiplayer_peer = null


#acceptance test
func test_join_botton():
	connection_scene._on_join_button_pressed()
	assert_not_same(multiplayer.get_unique_id(), 1, "when pressing join, peer object should be instantiated and not set to 1 (1 means server)")


#acceptance test
func test_host_botton():
	connection_scene._on_host_button_pressed()
	assert_eq(multiplayer.is_server(), true, "pressing host sets the peer object to server")


#White Box Test: function provided below
#func set_peer_host():
#	peer = ENetMultiplayerPeer.new()
#	var error = peer.create_server(port, 32)
#	if error != OK:
#		print("cannot host" + str(error))
#		return
#		
#	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
#	multiplayer.set_multiplayer_peer(peer)
#	print("Waiting for players...")
#			
#	if not OS.has_feature("dedicated_server"):
#		GameManager.instantiate_player(1)
# receives 100% coverage. First set_peer_call sets the multiplayer peer object and spawns player. Second runs the error catch
func test_hosting_error():
	ConnectionHandler.set_peer_host()
	connection_scene._on_host_button_pressed()
	assert_eq(multiplayer.is_server(), true, "pressing host when already hosting should not change the peer object")
