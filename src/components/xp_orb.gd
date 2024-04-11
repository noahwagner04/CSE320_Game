extends Area2D

var xp_value: int = 100
var xp_direction: Vector2 = Vector2(0.0, 0.0)

@onready var motion_controller = $MotionController
@onready var col_detector = $ColliderDetector
var _target: Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_target = col_detector.get_closest_collider()
	
	if _target == null:
		motion_controller.apply_friction(delta)
	else:
		motion_controller.move(global_position.direction_to(_target.global_position), delta)
	
	position += motion_controller.velocity * delta


func _on_body_entered(body):
	if not body is Player:
		return
	body.player_stats.gain_xp(xp_value)
	queue_free()
