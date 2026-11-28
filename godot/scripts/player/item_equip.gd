extends Node3D
class_name ItemEquip

signal remove_blocked
signal remove_unblocked

var item:ItemData
var instance:Item3D

func force_equip(new:ItemData):
	force_unequip()

	item = new
	instance = Global.item_lib.get_new_instance(new.id)
	if instance:
		instance._load_from_data(item)
		add_child(instance)

		instance.remove_blocked.connect(remove_blocked.emit)
		instance.remove_unblocked.connect(remove_unblocked.emit)

func equip_item(new:ItemData) -> bool:
	if !unequip(): return false
	if !new: return true

	item = new
	instance = Global.item_lib.get_new_instance(new.id)
	if instance:
		instance._load_from_data(item)
		add_child(instance)

		instance.remove_blocked.connect(remove_blocked.emit)
		instance.remove_unblocked.connect(remove_unblocked.emit)

	return true

func force_unequip():
	if !item: return

	if instance:
		instance._unload_into_data(item)
		instance.queue_free()
	item = null
	instance = null

func unequip() -> bool:
	if !instance: return true
	if !can_unequip(): return false

	if instance:
		instance._unload_into_data(item)
		instance.queue_free()
	item = null
	instance = null

	return true

func can_unequip() -> bool:
	if !instance: return true
	return instance.can_unequip()

func _unhandled_input(event: InputEvent) -> void:
	if instance:
		instance._item_input(event)
