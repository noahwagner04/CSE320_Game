extends GutTest

var hurt_hit_test_scene: Node2D
var children: Array[Node]
var hit_box: HitBox
var hurt_box: HurtBox
var health_container: HealthContainer


func before_each():
	hurt_hit_test_scene = preload("res://test/scenes/hit_hurt_box_test.tscn").instantiate()
	add_child_autofree(hurt_hit_test_scene)
	children = hurt_hit_test_scene.get_children()
	hit_box = children.filter(func(obj): return obj is HitBox)[0]
	hurt_box = children.filter(func(obj): return obj is HurtBox)[0]
	health_container = children.filter(func(obj): return obj is HealthContainer)[0]


# Bottom-Up test of HurtBox and HealthContainer classes
func test_damage_health_on_hurt():
	watch_signals(hurt_box)
	hit_box.position = Vector2.ZERO
	await wait_for_signal(hurt_box.hurt, 1)
	assert_true(is_equal_approx(health_container.health, 99), "health must deplete when hurt box is damaged")
