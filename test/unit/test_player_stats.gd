extends GutTest


var player_stats : PackedScene

func before_each():
	player_stats = preload("res://src/components/player_stats.tscn")
	add_child(player_stats)
	

#acceptance test
func test_stats_init():
	assert_true(is_equal_approx(player_stats.health, 100), "health should be 100 upon character creation")
