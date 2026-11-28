# Item that is instantiated when an item is equipped
extends Node3D
class_name Item3D

signal remove_blocked
signal remove_unblocked

## When first instantiated, loads state
func _load_from_data(_data:ItemData):
	pass

## When unloaded, stores state
func _unload_into_data(_data:ItemData):
	pass

## input passed onto the item from whatever thing is holding it.
func _item_input(_event:InputEvent):
	pass

## item can be unequipped
func can_unequip() -> bool:
	return true




## used by the initializing to check whether the expected data type is stored in the
func __check_data_type(_data:ItemData) -> bool:
	return false
