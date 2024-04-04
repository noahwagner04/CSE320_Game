extends Node

@export var sprite: Texture
@export var sound_effect: AudioStream
@export var loot_table: LootTable
@export var xp_drop_amount: int
@export var life_time: float = 10

var death_handler: PackedScene = preload("res://src/components/death_handler.tscn")

func perform_death():
	# instantiate death handler
	# set all the child nodes to the correct values
	# add the death handler to a child of the root node
	pass
