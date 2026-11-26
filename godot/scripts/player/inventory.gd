extends Node
class_name PlayerInventory

@export var body_containers:Array[ItemContainer]

func _ready() -> void:
	pass

# func get_weight():
# 	var mass := 0.0
# 	for container in containers:
# 		mass += container.get_mass()
# 	return mass
#
# func add_item(item:ItemData) -> bool:
# 	for container in containers:
# 		if container.add_item(item): return true
# 	return false
#
# func add_item_at(item:ItemData, container:int, pos:Vector2i) -> bool:
# 	if container < 0 or container >= containers.size(): return false
# 	var con := containers[container]
# 	return con.add_item(item, pos)
#
# func get_item(container:int, pos:Vector2i) -> ItemData:
# 	if container < 0 or container >= containers.size(): return null
# 	var con := containers[container]
# 	return con.get_at_point(pos)
