extends RigidBody3D
class_name ItemPickup

@export var preloaded_item:StringName

var item:ItemData

func _ready() -> void:
	if !preloaded_item:
		if !item: queue_free()
		return
	item = Global.item_lib.get_new(preloaded_item)
	if !item: queue_free()

func take() -> ItemData:
	queue_free()
	return item
