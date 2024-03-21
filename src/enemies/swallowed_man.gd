extends CharacterBody2D

@export var agro_dist: float = 400

var player_dist: float

@onready var health_container: HealthContainer = $HealthContainer
@onready var motion_controller: MotionController = $MotionController
@onready var player: Node = get_tree().get_first_node_in_group("player")


func _physics_process(delta):
	if (player == null):
		queue_free()
		return
		
	player_dist = global_position.distance_to(player.global_position)
	var move_dir: Vector2
	if player_dist <= agro_dist:
		move_dir = global_position.direction_to(player.global_position)
	else:
		queue_free()
		return
	
	motion_controller.move(move_dir, delta)
	velocity = motion_controller.velocity
	move_and_slide()


func _on_health_container_health_depleted():
	queue_free()


func _on_hurt_box_hurt(hit_box):
	#play sound?
	pass
