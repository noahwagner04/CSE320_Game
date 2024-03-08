extends GutTest


var player_stats : PackedScene
var player_menu : PackedScene
var stats_instance : Node
var menu_instance: Node

func before_each():
	player_stats = preload("res://src/components/player_stats.tscn")
	stats_instance = player_stats.instantiate()
	player_menu = preload("res://test/scenes/player_menu_test.tscn")
	menu_instance = player_menu.instantiate()
	add_child_autofree(stats_instance)
	add_child_autofree(menu_instance)

#Bottom Up test of PlayerStats scene and PlayerMenu scene
#Checking if data is pulled from PlayerStats and accurately displayed through PlayerMenu
func test_health_rendering():
	assert_true(menu_instance.health_label.text == "Health 100", "Initial rendering should get 100 health from player_stats and display it accurately")

func test_attack_rendering():
	assert_true(menu_instance.attack_label.text == "Attack 10 (+4)", "Initial rendering should get 10 (+4) attack from player_stats and display it accurately")
	
func test_level_up_health_rendering():
	stats_instance.levelUp()
	assert_true(menu_instance.health_label.text == "Health 120", "After level up should render Health 120")
	
func test_level_up_attack_rendering():
	stats_instance.levelUp()
	assert_true(menu_instance.attack_label.text == "Attack 12 (+4)", "After level up should render Attack 12 (+4)")

