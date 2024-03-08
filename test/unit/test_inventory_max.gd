extends GutTest

var inventory_data: InventoryData = preload("res://src/test_inv.tres")
var emptyIndex: int = 10
var twoApplesIndex: int = 7
var tenApplesIndex: int = 2
var daggerIndex: int = 1
var daggerSlotData: SlotData = inventory_data.slot_datas[daggerIndex]
var grabbed_slot_data: SlotData
var initialQuantity: int = 2

func before_each():
	# reset index 10
	inventory_data.slot_datas[emptyIndex] = null
	assert_true(inventory_data.slot_datas[emptyIndex] == null, "index 10 is empty")
	# reset ten apples
	inventory_data.slot_datas[tenApplesIndex].set_quantity(10)
	assert_true(inventory_data.slot_datas[tenApplesIndex].item_data.name == "Apple" && inventory_data.slot_datas[tenApplesIndex].quantity == 10,  "index 2 contains ten apples")
	grabbed_slot_data = inventory_data.slot_datas[twoApplesIndex]
	assert_true(grabbed_slot_data.item_data.name == "Apple" && grabbed_slot_data.quantity == initialQuantity, "item_data = apple.tres, quantity = 2")

# the three tests below are testing this drop_slot_data function from inventory_data.gd
'''
func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	var return_slot_data: SlotData
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data
		
	inventory_updated.emit(self)
	return return_slot_data
'''


# along with test_drop_into_same_stackable_item and test_drop_into_diff_item, achieves 100% branch coverage
func test_drop_into_empty():
	assert_true(inventory_data.drop_slot_data(grabbed_slot_data, emptyIndex) == null, "after dropping items to an empty slot, grabbed_slot_data should be null")
	assert_true(inventory_data.slot_datas[emptyIndex].item_data.name == "Apple" && inventory_data.slot_datas[emptyIndex].quantity == initialQuantity, "after dropping 2 items into an empty slot, the empty slot should now contain the grabbed_slot_data with quantity two")


# along with test_drop_into_empty and test_drop_into_diff_item, achieves 100% branch coverage
func test_drop_into_same_stackable_item():
	assert_true(inventory_data.drop_slot_data(grabbed_slot_data, tenApplesIndex) == null, "after dropping items into a slot containing the same stackable item, grabbed_slot_data should be null")
	assert_true(inventory_data.slot_datas[tenApplesIndex].item_data.name == "Apple" && inventory_data.slot_datas[tenApplesIndex].quantity == initialQuantity+10, "after dropping 2 items into a slot with ten apples, the slot should now contain the original quantity plus what we dropped (10+2)")


# along with test_drop_into_empty and test_drop_into_same_stackable_item, achieves 100% branch coverage
func test_drop_into_diff_item():
	assert_true(inventory_data.drop_slot_data(grabbed_slot_data, daggerIndex) == daggerSlotData, "after dropping items into a slot containing a different item, grabbed_slot_data should be that item")
	assert_true(inventory_data.slot_datas[daggerIndex].item_data.name == "Apple" && inventory_data.slot_datas[daggerIndex].quantity == initialQuantity, "after dropping 2 items into a slot with a dagger, the slot should now contain the original grabbed_slot_data with quantity two")
