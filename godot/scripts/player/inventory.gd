extends Node
class_name PlayerInventory

signal container_added(container:ContainerItem)
signal container_removed(container:ContainerItem)
signal body_item_added(item:ItemData, container:int)
signal body_item_removed(item:ItemData, container:int)

@export var body_containers:Array[ItemContainer]			# ItemContainer is container base class, ContainerItem is item class for a item that is a container!!!!!!! why did i name it that

var stored_containers:Array[ContainerItem]

func _ready() -> void:
	container_added.connect(_on_container_added)
	container_removed.connect(_on_container_removed)

	for c in body_containers.size():
		stored_containers.append_array(body_containers[c].get_container_items())

		body_containers[c].item_added.connect(_on_item_added.bind(c))
		body_containers[c].item_removed.connect(_on_item_removed.bind(c))

func get_weight():
	var mass := 0.0
	for container in body_containers:
		mass += container.get_mass()
	return mass


func add_body_slot_item(item:ItemData) -> bool:
	for container in body_containers:
		if container.add_item(item): return true
	return false

func add_body_slot_item_at(item:ItemData, container:int, pos:Vector2i) -> bool:
	if container < 0 or container >= body_containers.size(): return false
	var con := body_containers[container]
	return con.add_item(item, pos)

func get_body_slot_item(container:int, pos:Vector2i) -> ItemData:
	if container < 0 or container >= body_containers.size(): return null
	var con := body_containers[container]
	return con.get_at_point(pos)






func _on_item_added(item:ItemData, container:int):
	body_item_added.emit(item, container)
	if item is ContainerItem:
		stored_containers.append(item)
		container_added.emit(item)

func _on_item_removed(item:ItemData, container:int):
	body_item_removed.emit(item, container)
	if item is ContainerItem:
		stored_containers.erase(item)
		container_removed.emit(item)

func _on_container_added(container:ContainerItem) -> void:
	pass

func _on_container_removed(container:ContainerItem) -> void:
	pass
