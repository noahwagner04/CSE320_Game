extends GutTest

var health_container: HealthContainer

func before_each():
	health_container = preload("res://src/components/health_container.tscn").instantiate()
	add_child_autofree(health_container)


# acceptance test
func test_health_init():
	assert_true(is_equal_approx(health_container.health, health_container.max_health), "health must equal max_health initially")


# acceptance test
func test_damage():
	health_container.damage(10)
	assert_true(is_equal_approx(health_container.health, 90), "health must correctly subtract damage amount")


# acceptance test
func test_damage_below_zero():
	health_container.damage(1000)
	assert_true(is_zero_approx(health_container.health), "health must not go below 0")


# acceptance test
func test_damage_signal():
	watch_signals(health_container)
	health_container.damage(20)
	assert_signal_emitted_with_parameters(health_container, "health_changed", [-20.0])


# acceptance test
func test_death_signal():
	watch_signals(health_container)
	health_container.damage(1000)
	assert_signal_emitted(health_container, "health_depleted")


# acceptance test
func test_heal():
	health_container.health = 50
	health_container.heal(10)
	assert_true(is_equal_approx(health_container.health, 60), "health must correctly add heal amount")


# acceptance test
func test_heal_above_max():
	health_container.heal(1000)
	assert_true(is_equal_approx(health_container.health, health_container.max_health), "health must not go above max_health")


# acceptance test
func test_heal_signal():
	watch_signals(health_container)
	health_container.health = 50
	health_container.heal(20)
	assert_signal_emitted_with_parameters(health_container, "health_changed", [20.0])
