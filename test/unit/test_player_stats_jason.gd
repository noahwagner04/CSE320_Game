extends GutTest


var player_stats : PackedScene
var instance : Node

func before_each():
	player_stats = preload("res://src/components/player_stats.tscn")
	instance = player_stats.instantiate()
	add_child_autofree(instance)

#acceptance test
func test_stats_health_init():
	assert_true(is_equal_approx(instance.health, 100), "health should be 100 upon character creation")

#acceptance test
func test_stats_defense_init():
	assert_true(is_equal_approx(instance.defense, 10), "defense should be 10 upon character creation")

#acceptance test
func test_stats_level_init():
	assert_true(is_equal_approx(instance.level, 1), "level should be 1 upon character creation")

#acceptance test
func test_xp_gain():
	instance.gain_xp(50)
	assert_true(is_equal_approx(instance.xp, 50), "Should have 50 xp after doing gain_xp(50)")

#acceptance test
func test_levelup_xp_not_beyond_threshold():
	instance.gain_xp(50)
	assert_true(is_equal_approx(instance.level, 1), "level should remain 1 after gaining <100 xp")

#acceptance test
func test_levelup_xp_beyond_threshold():
	instance.gain_xp(150)
	assert_true(is_equal_approx(instance.level, 2), "level should be 2 after gaining 100+ xp")
	
#acceptance test
func test_health_after_level_up():
	instance.levelUp()
	assert_true(is_equal_approx(instance.health, 120), "Health should be 120 after first level up")
	
#acceptance test
func test_health_after_level_up_twice():
	instance.levelUp()
	instance.levelUp()
	assert_true(is_equal_approx(instance.health, 140), "Health should be 140 after second level up")

#acceptance test
func test_defense_after_level_up():
	instance.levelUp()
	assert_true(is_equal_approx(instance.defense, 12), "Defense should be 12 after first level up")

#acceptance test
func test_defense_after_level_up_twice():
	instance.levelUp()
	instance.levelUp()
	assert_true(is_equal_approx(instance.defense, 14), "Defense should be 14 after second level up")

