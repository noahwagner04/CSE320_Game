extends Node

var xp : int = 0;
var level : int = 0;

@export var health : int = 100;
var defense : int;
var hp_regen : int;
var attack : int;
var dexterity : int;
var speed : int;
var sp_regen : int;
var stamina : int;

var xp_level_thresholds = [100, 300, 700, 1300, 2000]

#Call when enemy is killed or quest is completed
func gain_xp(amount):
	xp += amount;
	checkLevelUp()

# Checks if a character meets a threshold requried for leveling up
func checkLevelUp():
	if xp > xp_level_thresholds[level]:
		levelUp()

# level up the character
func levelUp():
	level += 1
	#Open level up UI
	#Need to determine how stat increases will work based on chosen class. 

signal health_changed(new_health: int)

func set_health(new_health):
	health = new_health
	emit_signal("health_changed",health)


# Called when the node enters the scene tree for the first time.
func _ready():
	set_health(100)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
