extends ItemData
class_name ContainerItem

@export var container:ItemContainer

var net_mass := 0.0

func item_initialize() -> void:
	container.items_changed.connect(update_mass)
	update_mass()

func update_mass() -> void:
	net_mass = container.get_mass() + mass

func get_container() -> ItemContainer:
	return container
