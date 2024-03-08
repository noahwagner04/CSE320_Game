extends GutTest

var behemoth_vole: CharacterBody2D
var health_container: HealthContainer


func before_each():
	behemoth_vole = preload("res://src/enemies/boss_behemoth_vole.tscn").instantiate()
	add_child_autofree(behemoth_vole)
	health_container = $behemoth_vole_boss/HealthContainer


# Bottom-up Integration
func test_second_phase_if_above_half_max_hp():
	health_container.health = 0.7 * health_container.max_health
	await behemoth_vole._on_hurt_box_hurt(null)
	print(health_container.health)
	print(behemoth_vole.second_phase)
	assert_false(behemoth_vole.second_phase)


func test_second_phase_if_at_half_max_hp():
	health_container.health = 0.5 * health_container.max_health
	await behemoth_vole._on_hurt_box_hurt(null)
	print(health_container.health)
	print(behemoth_vole.second_phase)
	assert_true(behemoth_vole.second_phase)
	
	
func test_second_phase_if_below_half_max_hp():
	#behemoth_vole.second_phase = false
	health_container.health = 0.3 * health_container.max_health
	await behemoth_vole._on_hurt_box_hurt(null)
	print(health_container.health)
	print(behemoth_vole.second_phase)
	assert_true(behemoth_vole.second_phase)
