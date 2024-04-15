extends CharacterBody2D

@export var agro_dist: float = 400

@onready var health_container: HealthContainer = $HealthContainer
@onready var motion_controller: MotionController = $MotionController
@onready var player: Node = get_tree().get_first_node_in_group("player")
@onready var xp_dropper = $xp_dropper

var skelhurt = load("res://assets/bear-trap-103800.mp3")
var skeldeath = load("res://assets/wraithdeath.mp3")

func _physics_process(delta):
	if (player == null):
		queue_free()
		return
		
	var player_dist: float = global_position.distance_to(player.global_position)
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
	xp_dropper.drop_xp()
	queue_free()


func _on_hurt_box_hurt(_hit_box):
	$SkelPlayer.stream = skelhurt
	$SkelPlayer.play()
	pass
