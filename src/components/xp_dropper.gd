extends Node2D
class_name Xp_Dropper

#@onready var spawner_node = $Spawner

@export_range(5,50,5) var xp_drop_amount = 5
var num_orbs = 0

func drop_xp():
	#add_child(spawner_node)
	print("Inside of drop_xp() in xp_dropper.gd")
	var num = xp_drop_amount / 5
	print("Dropping")
	print(num)
	print("orbs")
	for i in range (1, num):
		pass
		#spawner_node.spawn()
	#Calls spawner
