extends Node2D

@onready var spawner_node = $Spawner

@export_range(10,200,10) var xp_drop_amount = 5
var num_orbs = 0

func drop_xp():
	var num = xp_drop_amount / 10
	for i in range (0, num):
		spawner_node.spawn()
