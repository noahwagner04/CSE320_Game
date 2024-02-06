extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_button_pressed():
	ConnectionManager.set_peer_host()
	ConnectionManager.player_name = $NameTextFeild.text	
	get_tree().change_scene_to_file("res://src/main.tscn")


func _on_join_button_pressed():
	ConnectionManager.set_peer_client()	
	ConnectionManager.player_name = $NameTextFeild.text
	get_tree().change_scene_to_file("res://src/main.tscn")
