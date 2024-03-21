extends Node2D

@export_category("Enemy")
@export_enum("Minor", "Major", "Boss") var enemy_type
@export_range(1, 5, 1) var enemy_tier: int
const PickUp = preload("res://src/inventory/pick_up.tscn")
var slot_data: SlotData


@export_category("Weapons")
@export_group("Dagger")
@export var dagger_drop: bool
@export_flags("1", "2", "3", "4", "5") var dagger_rarities
var dagger1 = preload("res://src/items/dagger1.tres")

@export_group("Mage Staff")
@export var mage_staff_drop: bool
@export_flags("1", "2", "3", "4", "5") var mage_staff_rarities


@export_category("Consumables")
@export_group("Healing Potion")
@export var healing_potion_drop: bool
var healing_potion = preload("res://src/items/health_potion.tres")

func _ready():
	# do math or whatever.
	# this can be changed to whatever. Either we can pick individual rarities and items
	# or we can use a pre-determined set loadout for things like rank and file enemies.
	# I don't mind any way.
	pass
	
func on_death():
	if randf() < 0.8:
		return
	slot_data = SlotData.new()
	slot_data.item_data = healing_potion
	slot_data.quantity = 1
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = global_position
	get_node("/root").add_child(pick_up)
