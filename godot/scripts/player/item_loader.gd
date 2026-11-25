extends Node3D

@export var id:StringName

var loaded:Item3D
var item:ItemData

func _ready() -> void:
	item = Global.item_lib.get_new(id)
	if !item: return
	var node:Item3D = item.item_scene.instantiate()
	add_child(node)
	node._load_from_data(item)
	loaded = node

func _unhandled_input(event: InputEvent) -> void:
	if loaded:
		loaded._item_input(event)
