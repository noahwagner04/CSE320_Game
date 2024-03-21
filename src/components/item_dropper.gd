extends Node2D

#@export var minorL1: LootTable

#@export_category("Enemy")
#@export_enum("Minor", "Major", "Boss") var enemy_type
#@export_range(1, 20, 1) var enemy_level: int

const PickUp = preload("res://src/inventory/pick_up.tscn")
var slot_data: SlotData
@export var loot_table: LootTable

# Weapons
#var weapons: Array[bool] = [loot_table.dagger_drop, loot_table.mage_staff_drop]
var valid_weapons: Array[String] = []

var dagger1 = preload("res://src/items/dagger1.tres")
var dagger2 = preload("res://src/items/dagger2.tres")
var dagger3 = preload("res://src/items/dagger3.tres")
var dagger4 = preload("res://src/items/dagger4.tres")
var dagger5 = preload("res://src/items/dagger5.tres")

# Consumables
#var consumables: Array[bool] = [loot_table.healing_potion]
#var consumable_drop_rates: Array[float] = [loot_table.healing_potion_drop_rate]
var valid_consumables: Array[String] = []

var healing_potion = preload("res://src/items/health_potion.tres")


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
	# determine range of possible drop numbers
	#if loot_table.max_weapon_drops != 0:
		#var num_occurences = randi_range(loot_table.min_weapon_drops, loot_table.max_weapon_drops)
		#for occurence in num_occurences:
			#if num_occurences == 0:
				#break
			## find random weapon
			#var weapon_name = valid_weapons[randi() % valid_weapons.size()]
			#print(weapon_name)
			#do_weapon(weapon_name)
	
	if loot_table.max_weapon_drops != 0:
		for ii in loot_table.max_weapon_drops:
			# find random weapon
			var weapon_name = valid_weapons[randi() % valid_weapons.size()]
			print(weapon_name)
			do_weapon(weapon_name)	
	
func do_weapon(weapon_name: String):
	# determine tier
	#var weapon_dict_array
	#var weapon_tier_name
	#match weapon_name:
		#"dagger":
			#weapon_dict_array = loot_table.daggers
		#"mage_staff":
			#weapon_dict_array = loot_table.mage_staffs
	#print(weapon_dict_array)
	#for weapon_dict in weapon_dict_array:
		#weapon_tier_name = weapon_dict.name
		#print(weapon_tier_name)
	var total_probability: float = 0
	var rand_float = randf()
	var weapon_tier: int
	for weapon_dict in loot_table.weapon_dict_array:
		total_probability += (weapon_dict.drop_rate / 100)
		if rand_float < total_probability:
			weapon_tier = weapon_dict.tier
			break
	if weapon_tier == null:
		print("Developer should make sure all weapon drop rates add to 100%")
		return
	print(weapon_tier)
			
		


	
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
	slot_data = SlotData.new()
	slot_data.item_data = healing_potion
	slot_data.quantity = 1
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = global_position
	get_node("/root").add_child(pick_up)

