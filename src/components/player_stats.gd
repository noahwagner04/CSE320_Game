extends Node

var xp : int = 0;
var level : int = 0;

var health : int;
var defense : int;
var hp_regen : int;
var attack : int;
var dexterity : int;
var speed : int;
var sp_regen : int;
var stamina : int;

var xp_level_thresholds = [100, 300, 700, 1300, 2000]

func gain_xp(amount):
	xp += amount;
	checkLevelUp()

func checkLevelUp():
	if xp > xp_level_thresholds[level]:
		levelUp()

func levelUp():
	level += 1
	#Need to determine how stat increases will work based on chosen class. 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
