extends Node

var player

func use_slot_data(slot_data: SlotData):
	slot_data.item_data.use(player)
