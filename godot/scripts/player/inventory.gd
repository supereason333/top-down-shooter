extends Node
class_name PlayerInventory

signal container_added(container:ContainerItem, old_id:int)
signal container_removed(container:ContainerItem, old_id:int)
signal body_item_added(item:ItemData, container:int)
signal body_item_removed(item:ItemData, container:int)

@export var body_containers:Array[ItemContainer]			# ItemContainer is container base class, ContainerItem is item class for a item that is a container!!!!!!! why did i name it that
@export var preload_items:Array[StringName]		# stuff to load into inventory at ready

var stored_containers:Array[ContainerItem]

func _ready() -> void:
	container_added.connect(_on_container_added)
	container_removed.connect(_on_container_removed)

	for c in body_containers.size():
		stored_containers.append_array(body_containers[c].get_container_items())

		body_containers[c].item_added.connect(_on_item_added.bind(c))
		body_containers[c].item_removed.connect(_on_item_removed.bind(c))


	for preload_item in preload_items:
		var item := Global.item_lib.get_new(preload_item)
		if !item: continue
		add_item(item)

func get_weight():
	var mass := 0.0
	for container in body_containers:
		mass += container.get_mass()
	return mass


func add_item(item:ItemData) -> bool:
	for container in body_containers:
		if !container.can_add(item): continue
		if container.add_item(item): return true
	for container_item in stored_containers:
		var container := container_item.get_container()
		if !container.can_add(item): continue
		if container.add_item(item): return true
	return false




# func add_body_slot_item_at(item:ItemData, container:int, pos:Vector2i) -> bool:
# 	if container < 0 or container >= body_containers.size(): return false
# 	var con := body_containers[container]
# 	return con.add_item(item, pos)
#
# func get_body_slot_item(container:int, pos:Vector2i) -> ItemData:
# 	if container < 0 or container >= body_containers.size(): return null
# 	var con := body_containers[container]
# 	return con.get_at_point(pos)


func get_container_item(container:int, pos:Vector2i) -> ItemData:
	if container < 0 or container >= stored_containers.size(): return null
	var con := stored_containers[container]
	return con.get_container().get_at_point(pos)

func get_body_container_item(container:int, pos:Vector2i) -> ItemData:
	if container < 0 or container >= body_containers.size(): return null
	return body_containers[container].get_at_point(pos)




func _on_item_added(item:ItemData, container:int):
	body_item_added.emit(item, container)
	if item is ContainerItem:
		stored_containers.append(item)
		container_added.emit(item)
		print("ADDED EMIT")

func _on_item_removed(item:ItemData, container:int):
	body_item_removed.emit(item, container)
	if item is ContainerItem:
		stored_containers.erase(item)
		container_removed.emit(item)
		print("REMOVED EMIT")

func _on_container_added(container:ContainerItem) -> void:
	pass

func _on_container_removed(container:ContainerItem) -> void:
	pass
