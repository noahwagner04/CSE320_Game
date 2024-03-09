extends GutTest

var behemoth_vole: CharacterBody2D
var health_container: HealthContainer


func before_each():
	behemoth_vole = preload("res://src/enemies/boss_behemoth_vole.tscn").instantiate()
	add_child_autofree(behemoth_vole)
	health_container = $behemoth_vole_boss/HealthContainer


# Acceptance test
func test_player_is_far():
	behemoth_vole.player_dist = 2 * behemoth_vole.agro_dist
	assert_eq(behemoth_vole._target, null)


# Acceptance test
func test_player_is_at_agro_dist():
	behemoth_vole.player_dist = behemoth_vole.agro_dist
	assert_ne(behemoth_vole._target, null)
	
	
# Acceptance test
func test_player_is_close():
	behemoth_vole.player_dist = behemoth_vole.agro_dist - 5
	assert_ne(behemoth_vole._target, null)
	

# Acceptance test
func test_has_not_spit_max_times():
	behemoth_vole.vomits = 0
	await behemoth_vole.spit_vomit()
	assert_eq(behemoth_vole.vomits, 1)
	
	
# Acceptance test
func test_has_spit_max_times():
	behemoth_vole.vomits = behemoth_vole.total_vomit_amount
	await behemoth_vole.spit_vomit()
	assert_eq(behemoth_vole.vomits, behemoth_vole.total_vomit_amount)
	

# Acceptance test
func test_has_spit_more_than_max_times():
	behemoth_vole.vomits = behemoth_vole.total_vomit_amount + 1
	await behemoth_vole.spit_vomit()
	assert_eq(behemoth_vole.vomits, behemoth_vole.total_vomit_amount + 1)
	

# Acceptance test	
func test_second_phase_if_above_half_max_hp():
	behemoth_vole.second_phase = false
	health_container.health = 0.7 * health_container.max_health
	await behemoth_vole._on_hurt_box_hurt(null)
	assert_false(behemoth_vole.second_phase)


# Acceptance test
func test_second_phase_if_at_half_max_hp():
	behemoth_vole.second_phase = false
	health_container.health = 0.5 * health_container.max_health
	await behemoth_vole._on_hurt_box_hurt(null)
	assert_true(behemoth_vole.second_phase)
	
	
# Acceptance test
func test_second_phase_if_below_half_max_hp():
	behemoth_vole.second_phase = false
	health_container.health = 0.3 * health_container.max_health
	await behemoth_vole._on_hurt_box_hurt(null)
	assert_true(behemoth_vole.second_phase)

