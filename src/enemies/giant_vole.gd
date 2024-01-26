extends CharacterBody2D

@export var speed : float = 100
@export var agro_dist : float = 300
@onready var player : Node = get_tree().get_first_node_in_group("player")
var _target : Node2D
var home : Node2D = Node2D.new()
var rand_target_mod = Vector2((randf() * 2 - 1) * 10, (randf() * 2 - 1) * 10)

func _ready():
	home.global_position = global_position
	speed += (randf() * 2 - 1) * 10

func _physics_process(_delta):
	var player_dist = agro_dist + 1
	if player != null:
		player_dist = global_position.distance_to(player.global_position)
	if player_dist < agro_dist:
		_target = player
	else:
		_target = home
	
	var new_target = _target.global_position + rand_target_mod
	
	# stop movement if we are on target
	if global_position.distance_to(new_target) < speed * _delta:
		global_position = new_target
		return
	
	velocity = (new_target - global_position).normalized() * speed
	move_and_slide()
