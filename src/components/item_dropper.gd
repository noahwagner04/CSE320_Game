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
const health_potion = preload("res://src/items/health_potion.tres")
const stamina_potion = preload("res://src/items/stamina_potion.tres")
const monsters_energy = preload("res://src/items/monster's_energy.tres")

var valid_consumables: Array[String] = []



func _ready():
	loot_table.set_non_exported_vals()

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
	var item_data = weapon_resource_dict[resource_dict_key]
	drop_item(item_data)
	
	
func do_health_potion():
	drop_item(health_potion)
	
			
		
func drop_item(item_data: ItemData):
	var slot_data = SlotData.new()
	slot_data.item_data = item_data
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = global_position
	get_node("/root").add_child(pick_up)

	
func on_death():
	# health potion drops
	var min_health_potion_drops = loot_table.min_health_potion_drops
	var max_health_potion_drops = loot_table.max_health_potion_drops
	while min_health_potion_drops > 0:
		do_health_potion()
		min_health_potion_drops -= 1
		max_health_potion_drops -= 1
	if max_health_potion_drops > 0:
		for ii in max_health_potion_drops:
			# check if health potion will drop
			if randf_range(0, 100) > loot_table.health_potion_drop_rate:
				continue
			do_health_potion()
			
	# determine valid weapon drops
	for weapon in loot_table.weapons_dict:
		if loot_table.weapons_dict[weapon]:
			valid_weapons.append(weapon)
	
	# weapon drops
	var min_weapon_drops = loot_table.min_weapon_drops
	var max_weapon_drops = loot_table.max_weapon_drops
	while min_weapon_drops > 0:
		var weapon_name = valid_weapons[randi() % valid_weapons.size()]
		do_weapon(weapon_name)
		min_weapon_drops -= 1
		max_weapon_drops -= 1
	if max_weapon_drops > 0: 
		for ii in max_weapon_drops:
			# check if weapon will drop
			if randf_range(0, 100) > loot_table.weapon_drop_chance:
				continue
			# find random weapon
			var weapon_name = valid_weapons[randi() % valid_weapons.size()]
			do_weapon(weapon_name)
