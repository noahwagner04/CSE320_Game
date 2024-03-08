extends GutTest

var player_stats : PackedScene
var instance : Node

func before_each():
	player_stats = preload("res://src/components/player_stats.tscn")
	instance = player_stats.instantiate()
	add_child_autofree(instance)

# Checking the two paths that this function can take, when xp is greater than and less than the first threshold which is 100
#func checkLevelUp():
	#if xp >= xp_level_thresholds[level - 1]:
		#levelUp()

# These two tests together achieve 100% branch coverage
func test_xp_less_than_threshold():
	instance.xp = 50
	instance.checkLevelUp()
	assert_true(is_equal_approx(instance.level, 1), "Player should remain level 1 because 50 is not beyond the threshold of 100 xp")

func test_xp_greater_than_threshold():
	instance.xp = 150
	instance.checkLevelUp()
	assert_true(is_equal_approx(instance.level, 2), "Player should be level 2 because 150 is beyond the threshold of 100 xp and levelUp() should run")
