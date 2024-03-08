extends GutTest

var hurt_hit_test_scene: Node2D
var children: Array[Node]
var hit_box: HitBox
var hurt_box: HurtBox
var health_container: HealthContainer
var motion_controller: MotionController


func before_each():
	hurt_hit_test_scene = preload("res://test/scenes/hit_hurt_box_test.tscn").instantiate()
	add_child_autofree(hurt_hit_test_scene)
	children = hurt_hit_test_scene.get_children()
	hit_box = children.filter(func(obj): return obj is HitBox)[0]
	hurt_box = children.filter(func(obj): return obj is HurtBox)[0]
	health_container = children.filter(func(obj): return obj is HealthContainer)[0]
	motion_controller = children.filter(func(obj): return obj is MotionController)[0]


# Bottom-Up testing of HurtBox and HitBox, ensuring poison values transfer
func test_poison_transfer():
	assert_false(hurt_box.poison_component.effect_active, "hurt_box should have its poison component effect inactive by default")
	hit_box.set_poison(true, 10, 10)
	assert_true(hit_box.poison_component.effect_active, "set_poison should work")
	
	watch_signals(hurt_box)
	hit_box.position = Vector2.ZERO
	await wait_for_signal(hurt_box.hurt, 1)
	
	assert_true(hurt_box.poison_component.effect_active, "poison values should transfer from hit_box to hurt_box")
	assert_true(is_equal_approx(hurt_box.poison_component.duration, 10), "duration value must also transfer")
	

# Continuing Noah's Bottom-Up testing of HurtBox and HealthContainer classes, specifically looking at effects
func test_is_poisoned():
	hit_box.set_poison(true, 10, 10)
	watch_signals(hurt_box)
	hit_box.position = Vector2.ZERO
	await wait_for_signal(hurt_box.hurt, 1)
	assert_true(hurt_box.is_poisoned, "is_poisoned must be active when poisoned")
	
func test_just_poisoned_signal():
	hit_box.set_poison(true, 10, 10)
	watch_signals(hurt_box)
	hit_box.position = Vector2.ZERO
	await wait_for_signal(hurt_box.just_poisoned, 1)
	assert_true(hurt_box.is_poisoned, "just_poisoned should only be emitted when hurt_box is poisoned")

func test_just_poisoned_signal2():
	watch_signals(hurt_box)
	hit_box.position = Vector2.ZERO
	await wait_for_signal(hurt_box.hurt, 3)
	# this signal should never occur
	assert_signal_not_emitted(hurt_box, "just_poisoned", "just_poisoned should only be emitted when hurt_box is poisoned")


func test_cannot_be_poisoned_twice():
	hit_box.set_poison(true, 10, 10)
	watch_signals(hurt_box)
	hit_box.position = Vector2.ZERO
	await wait_for_signal(hurt_box.hurt, 1)
	assert_signal_emitted(hurt_box, "just_poisoned")
	watch_signals(hurt_box)
	hit_box.position = Vector2(500, 500)
	hit_box.position = Vector2.ZERO
	await wait_for_signal(hurt_box.hurt, 1)
	assert_true(is_equal_approx(get_signal_emit_count(hurt_box, "just_poisoned"), 1), "just_poisoned should only have been emitted once")
