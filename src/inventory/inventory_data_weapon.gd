extends InventoryData
class_name InventoryDataWeapon

signal weapon_removed

func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	
	# check if weapon is legal for class
	
	if not grabbed_slot_data.item_data is ItemDataWeapon:
		return grabbed_slot_data
		
	weapon_changed.emit(grabbed_slot_data.item_data)
	
	return super.drop_slot_data(grabbed_slot_data, index)

func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	
	# check if weapon is legal for class
	
	if not grabbed_slot_data.item_data is ItemDataWeapon:
		return grabbed_slot_data
		
	weapon_changed.emit(grabbed_slot_data.item_data)
	
	return super.drop_single_slot_data(grabbed_slot_data, index)


func grab_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if slot_data:
		slot_datas[index] = null
		inventory_updated.emit(self)
		weapon_removed.emit()
		return slot_data
	else:
		return null
