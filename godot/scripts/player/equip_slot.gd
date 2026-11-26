extends Node
class_name EquipSlot

signal item_changed(item:ItemData)

var item_data:ItemData

## equips an item, if already has an item, return that item to swich out
func equip_item(item:ItemData) -> ItemData:
	if !item: return
	var old := item_data
	item_data = item
	item_changed.emit(item)
	return old

## removes the item, returns current if any is equipped
func remove_item() -> ItemData:
	if !item_data: return null
	var old := item_data
	item_data = null
	item_changed.emit(null)
	return old
