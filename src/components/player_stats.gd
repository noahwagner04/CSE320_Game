#class_name PlayerStats
extends Node

# This signal is connected to player_menu - when stats are modified the changes are reflected in the UI
signal player_leveled_up

@export var health: int

# Player base stats
@export var defense: int
@export var hp_regen: int
@export var attack: int
@export var dexterity: int
@export var speed: int
@export var sp_regen: int
@export var stamina: int

#Player stat modifiers
@export var defense_mod: int = -2
@export var hp_regen_mod: int = 3
@export var attack_mod: int = 4
@export var dexterity_mod: int = -1
@export var speed_mod: int = -9
@export var sp_regen_mod: int = 1
@export var stamina_mod: int = 1000

var xp_level_thresholds: Array[int] = [100, 300, 700, 1300, 2000, 3000]
var xp: int = 0
var level: int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set initial player stat values when character is created
	health = 100
	defense = 10
	hp_regen = 10
	attack = 10
	dexterity = 10
	speed = 10
	sp_regen = 10
	stamina = 10


#Call when enemy is killed or quest is completed
func gain_xp(amount):
	xp += amount;
	checkLevelUp()


# Checks if a character meets a threshold requried for leveling up
func checkLevelUp():
	var max_level = len(xp_level_thresholds)
	if level > max_level:
		return
	if xp >= xp_level_thresholds[level - 1]:
		levelUp()


# level up the character
func levelUp():
	health += 20
	defense += 2
	hp_regen += 2
	attack += 2
	dexterity += 2
	speed += 2
	sp_regen += 2
	stamina += 2
	level += 1
	emit_signal("player_leveled_up")
