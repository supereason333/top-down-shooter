# Each item has its item data, it keeps the state of the item and is the data that is stored
# when item is stored. The physical node item is only instantiated when the item is equipped
# and is freed when it is unequipped
# some things like id shouldn't be changed, use common sense or something
extends Resource
class_name ItemData

@export var display_name:String
@export var mass:float = 0.1

@export_storage var id:StringName

func get_master() -> ItemMasterData:
	return Global.item_lib.get_master(id)

func _item_initialise() -> void:
	pass
