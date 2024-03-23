extends Area2D

var xp_value: int = 5
var xp_direction: Vector2 = Vector2(0.0, 0.0)

var xp_speed: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	xp_speed = randf_range(1,10)
	var random_angle = randf_range(0, 2 * PI)
	xp_direction = Vector2(cos(random_angle), sin(random_angle))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += xp_direction * delta * xp_speed
	if xp_speed <= 0:
		xp_speed = 0
	else:
		xp_speed -= 0.1


func _on_body_entered(body):
	if not body is Player:
		return
	body.player_stats.xp += xp_value
	queue_free()
