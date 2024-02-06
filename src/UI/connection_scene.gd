extends Control

func _on_host_button_pressed():
	ConnectionManager.set_peer_host()
	ConnectionManager.player_name = $NameTextFeild.text
	visible = false


func _on_join_button_pressed():
	ConnectionManager.set_peer_client()
	ConnectionManager.player_name = $NameTextFeild.text
	visible = false
