extends Node2D

const PickUp = preload("res://src/inventory/pick_up.tscn")
@export var loot_table: LootTable

# Weapons
const dagger1 = preload("res://src/items/dagger1.tres")
const dagger2 = preload("res://src/items/dagger2.tres")
const dagger3 = preload("res://src/items/dagger3.tres")
const dagger4 = preload("res://src/items/dagger4.tres")
const dagger5 = preload("res://src/items/dagger5.tres")
const mage_staff1 = preload("res://src/items/mage_staff1.tres")
const mage_staff2 = preload("res://src/items/mage_staff2.tres")
const mage_staff3 = preload("res://src/items/mage_staff3.tres")
const mage_staff4 = preload("res://src/items/mage_staff4.tres")
const mage_staff5 = preload("res://src/items/mage_staff5.tres")
const weapon_resource_dict: Dictionary = {
	"dagger1": dagger1,
	"dagger2": dagger2,
	"dagger3": dagger3,
	"dagger4": dagger4,
	"dagger5": dagger5,
	"mage_staff1": mage_staff1,
	"mage_staff2": mage_staff2,
	"mage_staff3": mage_staff3,
	"mage_staff4": mage_staff4,
	"mage_staff5": mage_staff5
}

var valid_weapons: Array[String] = []

# Consumables
var valid_consumables: Array[String] = []

const health_potion = preload("res://src/items/health_potion.tres")


func _ready():
	loot_table.set_non_exported_vals()
	# determine drops when enemy spawns
	# go by category
	# do consumable drops
	# determine valid consumables
	# determine range of possible drops
	# if max is 0, then skip to next category
	# otherwise call do_consumables randf compared to range times in a loop
	# for weapons:
	# determine range, blah blah blah, call range times, determining random weapon
	# determine valid weapons
	for weapon in loot_table.weapons_dict:
		if loot_table.weapons_dict[weapon]:
			valid_weapons.append(weapon)
	
	if loot_table.max_weapon_drops != 0:
		for ii in loot_table.max_weapon_drops:
			# check if weapon will drop
			if randf_range(0, 100) > loot_table.weapon_drop_chance:
				continue
			# find random weapon
			var weapon_name = valid_weapons[randi() % valid_weapons.size()]
			do_weapon(weapon_name)	
	
func do_weapon(weapon_name: String):
	# determine tier
	var total_probability: float = 0
	var rand_float = randf()
	var weapon_tier: int = 0
	for weapon_dict in loot_table.weapon_dict_array:
		total_probability += (weapon_dict.drop_rate / 100)
		if rand_float < total_probability:
			weapon_tier = weapon_dict.tier
			break
	if weapon_tier == 0:
		print("Developer should make sure all weapon drop rates add to 100%")
		return
	var resource_dict_key = "%s%s" % [weapon_name, weapon_tier]
	var slot_data = SlotData.new()
	slot_data.item_data = weapon_resource_dict[resource_dict_key]
	drop_item(slot_data)
			
		
func drop_item(slot_data: SlotData):
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = global_position
	get_node("/root").add_child(pick_up)

	
#func do_consumables():
	#for consumable in loot_table.consumables:
		#var drop_chance = consumable_drop_rate / 100
		#print(drop_chance)
		#if randf() < drop_chance:
			#continue
		#print("dropped")
		#match consumable_drop_rate:
			#healing_potion:
				#print("healing potion")
	#pass
	
func on_death():
	if randf() < 0.8:
		return
	var slot_data = SlotData.new()
	slot_data.item_data = health_potion
	slot_data.quantity = 1
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = global_position
	get_node("/root").add_child(pick_up)

