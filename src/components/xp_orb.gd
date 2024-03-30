extends Area2D

var xp_value: int = 10
var xp_direction: Vector2 = Vector2(0.0, 0.0)

@onready var motion_controller = $MotionController
@onready var col_detector = $ColliderDetector
var home := Node2D.new()
var mult_sync: MultiplayerSynchronizer
var _rand_target_mod := Vector2((randf() * 2 - 1) * 10, (randf() * 2 - 1) * 10)
var _target: Node2D
var sync_pos := Vector2.ZERO

var xp_speed: float = 0
# Called when the node enters the scene tree for the first time.

func _ready():
	home.global_position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_target = col_detector.get_closest_collider()
	_target = home if _target == null else _target 

	var new_target = _target.global_position + _rand_target_mod
	
	motion_controller.move(global_position.direction_to(new_target), delta)
	position += motion_controller.velocity


func _on_body_entered(body):
	if not body is Player:
		return
	body.player_stats.gain_xp(xp_value)
	queue_free()
