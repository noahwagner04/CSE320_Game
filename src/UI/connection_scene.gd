extends Control

func _on_host_button_pressed():
	ConnectionHandler.set_peer_host()
	GameManager.player_name = $NameTextFeild.text
	visible = false


func _on_join_button_pressed():
	ConnectionHandler.set_peer_client()
	GameManager.player_name = $NameTextFeild.text
	visible = false
