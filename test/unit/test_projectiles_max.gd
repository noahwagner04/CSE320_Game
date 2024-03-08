extends GutTest

var player: CharacterBody2D
var dagger: Weapon
var projectile_spawner: Node2D
var hit_box: HitBox


func before_each():
	player = preload("res://src/player/player.tscn").instantiate()
	add_child_autofree(player)
	dagger = player.equipped_weapon
	projectile_spawner = dagger.projectile_spawner
	hit_box = preload("res://src/components/hit_box.tscn").instantiate()
	add_child_autofree(hit_box)


# acceptance test
func test_base_attack_speed_init():
	assert_true(is_equal_approx(dagger.base_attack_speed, 4.0), "any new dagger must have 4.0 base attack speeed")


# acceptance test
func test_base_damage_init():
	assert_true(is_equal_approx(dagger.base_projectile_damage, 6), "any new dagger must have 6 base damage")


# acceptance test
func test_set_rarity_bonuses():
	dagger.weapon_rarity = 5
	dagger.set_rarity_bonuses()
	assert_true(is_equal_approx(dagger.attack_speed, 4*2), "rarity of 5 should double base stats")


# acceptance test
func test_projectile_spawner_affected():
	assert_true(is_equal_approx(dagger.projectile_damage, projectile_spawner.projectile_damage), "weapon's values should be transferred to its projectile spawner")


# acceptance test
func test_projectile_poison_applies():
	dagger.projectile_spawner.set_poison_projectile_attributes(true, 3, 3)
	assert_true(is_equal_approx(dagger.projectile_spawner.poison_component.duration, 3), "projectile spawner's set_x_projectile_attributes should be able to be called at any point")


# acceptance test
func test_hit_box_set_poison():
	hit_box.set_poison(true, 3, 3)
	assert_true(is_equal_approx(hit_box.poison_component.duration, 3), "hit_box's poison component should be able to be changed at any point")

# acceptance test
func test_hit_box_set_knockback():
	hit_box.set_knockback(true, 6)
	assert_true(is_equal_approx(hit_box.knockback_component.knockback, 6), "hit_box's knockback component should be able to be changed at any point")
