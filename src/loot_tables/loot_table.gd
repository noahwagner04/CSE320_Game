extends Resource
class_name LootTable


@export_category("Weapons")
@export var min_weapon_drops: int = 0
@export var max_weapon_drops: int = 1
@export_range(0, 100, 0.1, "suffix: %") var weapon_t1_drop_rate: float = 0
@export_range(0, 100, 0.1, "suffix: %") var weapon_t2_drop_rate: float = 0
@export_range(0, 100, 0.1, "suffix: %") var weapon_t3_drop_rate: float = 0
@export_range(0, 100, 0.1, "suffix: %") var weapon_t4_drop_rate: float = 0
@export_range(0, 100, 0.1, "suffix: %") var weapon_t5_drop_rate: float = 0
var weapon_t1_dict
var weapon_t2_dict
var weapon_t3_dict
var weapon_t4_dict
var weapon_t5_dict
var weapon_dict_array: Array[Dictionary]
var sorted_weapon_dict_array: Array[Dictionary]

@export_group("Dagger")
@export var dagger_drop: bool
@export_range(0, 100, 0.1, "suffix: %") var dagger1_drop_rate: float = 0
@export_range(0, 100, 0.1, "suffix: %") var dagger2_drop_rate: float = 0
@export_range(0, 100, 0.1, "suffix: %") var dagger3_drop_rate: float = 0
@export_range(0, 100, 0.1, "suffix: %") var dagger4_drop_rate: float = 0
@export_range(0, 100, 0.1, "suffix: %") var dagger5_drop_rate: float = 0
var dagger1_dict
var dagger2_dict
var dagger3_dict
var dagger4_dict
var dagger5_dict
var daggers


@export_group("Mage Staff")
@export var mage_staff_drop: bool
@export_range(0, 100, 0.1, "suffix: %") var mage_staff1_drop_rate: float = 0
@export_range(0, 100, 0.1, "suffix: %") var mage_staff2_drop_rate: float = 0
@export_range(0, 100, 0.1, "suffix: %") var mage_staff3_drop_rate: float = 0
@export_range(0, 100, 0.1, "suffix: %") var mage_staff4_drop_rate: float = 0
@export_range(0, 100, 0.1, "suffix: %") var mage_staff5_drop_rate: float = 0
var mage_staff1_dict
var mage_staff2_dict
var mage_staff3_dict
var mage_staff4_dict
var mage_staff5_dict
var mage_staffs 
var weapons_dict

@export_category("Consumables")
@export var min_healing_potion_drops: int = 0
@export var max_healing_potion_drops: int = 1
@export_group("Healing Potion")
@export var healing_potion_drop: bool
@export_range(0, 100, 0.1, "suffix: %") var healing_potion_drop_rate: float = 0
var healing_potion = preload("res://src/items/health_potion.tres")
var healing_potion_dict
var consumables

func set_non_exported_vals():
	weapon_t1_dict = {
		"tier": 1, 
		"drop_rate": weapon_t1_drop_rate
	}
	weapon_t2_dict = {
		"tier": 2, 
		"drop_rate": weapon_t2_drop_rate
	}
	weapon_t3_dict = {
		"tier": 3, 
		"drop_rate": weapon_t3_drop_rate
	}
	weapon_t4_dict = {
		"tier": 4, 
		"drop_rate": weapon_t4_drop_rate
	}
	weapon_t5_dict = {
		"tier": 5, 
		"drop_rate": weapon_t5_drop_rate
	}
	weapon_dict_array = [weapon_t1_dict, weapon_t2_dict, weapon_t3_dict, weapon_t4_dict, weapon_t5_dict]
	weapon_dict_array.sort_custom(custom_dict_array_sort)
	
	
	dagger1_dict = {
		"name": "dagger1", 
		"drop_rate": dagger1_drop_rate
	}
	dagger2_dict = {
		"name": "dagger2", 
		"drop_rate": dagger2_drop_rate
	}
	dagger3_dict = {
		"name": "dagger3", 
		"drop_rate": dagger3_drop_rate
	}
	dagger4_dict = {
		"name": "dagger4", 
		"drop_rate": dagger4_drop_rate
	}
	dagger5_dict = {
		"name": "dagger5", 
		"drop_rate": dagger5_drop_rate
	}

	daggers = [dagger1_dict, dagger2_dict, dagger3_dict, dagger4_dict, dagger5_dict]
		
	mage_staff1_dict = {
		"name": "mage_staff1", 
		"drop_rate": mage_staff1_drop_rate
	}
	mage_staff2_dict = {
		"name": "mage_staff2", 
		"drop_rate": mage_staff2_drop_rate
	}
	mage_staff3_dict = {
		"name": "mage_staff3", 
		"drop_rate": mage_staff3_drop_rate
	}
	mage_staff4_dict = {
		"name": "mage_staff4", 
		"drop_rate": mage_staff4_drop_rate
	}
	mage_staff5_dict = {
		"name": "mage_staff5", 
		"drop_rate": mage_staff5_drop_rate
	}

	mage_staffs = [mage_staff1_dict, mage_staff2_dict, mage_staff3_dict, mage_staff4_dict, mage_staff5_dict]

	weapons_dict = {
		"dagger": dagger_drop,
		"mage_staff": mage_staff_drop
	}
	
	healing_potion_dict = {
		"name": "healing_potion", 
		"drop_rate": healing_potion_drop_rate
	}
	consumables = [healing_potion_dict]
	
	
func custom_dict_array_sort(dict_a: Dictionary, dict_b: Dictionary) -> bool:
	return dict_a.drop_rate > dict_b.drop_rate
	
