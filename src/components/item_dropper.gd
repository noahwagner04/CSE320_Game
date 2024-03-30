extends Node2D
class_name ItemDropper

# more settings for how to spawn the loot (as a child, globally, with an initial random position / rotation, etc)
@export var loot_table: LootTable
const PICK_UP = preload("res://src/inventory/pick_up.tscn")

var pools: Array[Pool]
var total_weight: int = 0

# unpack all the loot table scene entries here, probably put them in some data structure like an array or dictionary
func _ready():
	pools = loot_table.pools
	pass

# uses loot table information to drop the correct amount of items (from each pool using weights of each item)
# this function would be called when the enemy dies, chest gets looted, wall gets mined, etc.
func drop():
	for pool in pools:
		# handle a pool
		handle_pool(pool)
		
		
func handle_pool(pool: Pool):
	# sort in descending order
	pool.entries.sort_custom(custom_entry_array_sort)
	
	# find total weight
	total_weight = 0
	for entry in pool.entries:
		if entry == null:
			continue
		total_weight += entry.weight
	
	for ii in pool.rolls:
		# check if pool will actually roll
		if randf_range(0, 100) > pool.chance_to_roll:
			continue
		# roll pool
		roll_pool(pool)
		
		
func roll_pool(pool: Pool):
	var total_probability: float = 0
	var rand_float = randf()
	var item: ItemData
	for entry in pool.entries:
		total_probability += (float(entry.weight) / float(total_weight))
		if rand_float < total_probability:
			item = entry.item
			break
	if item == null:
		print("ERROR HAS OCCURRED")
		return
	drop_item(item)
	

func drop_item(item_data: ItemData):
	var slot_data = SlotData.new()
	slot_data.item_data = item_data
	var pick_up = PICK_UP.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = global_position
	get_node("/root").add_child(pick_up)
	

func custom_entry_array_sort(entry_a: Entry, entry_b: Entry) -> bool:
	return entry_a.weight > entry_b.weight
	
