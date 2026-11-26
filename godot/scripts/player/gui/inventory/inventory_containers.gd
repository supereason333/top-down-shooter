extends VBoxContainer

const HOVER_BUTTON:PackedScene = preload("uid://osckj4xj15i")

@onready var inventory:PlayerInventory = %Inventory

@onready var container_display:GridContainer = $ClearPanel/ContainerDisplay
@onready var item_overlay:Control = $ClearPanel/ItemOverlay
@onready var container_tab:HBoxContainer = $ContainerTabs
@onready var name_label:Label = $ContainerLabel

var displayed:Array[ItemContainer]

var selected:ItemContainer
var selected_id := 0

func _ready() -> void:
	for child in container_tab.get_children(): child.queue_free()
	for child in container_display.get_children(): child.queue_free()
	for child in item_overlay.get_children(): child.queue_free()

	inventory.container_added.connect(_on_container_added)
	inventory.container_removed.connect(_on_container_removed)

	for item in inventory.stored_containers:
		displayed.append(item.get_container())

	for c in inventory.stored_containers.size():
		var hover:HoverButton = HOVER_BUTTON.instantiate()
		hover.disabled = false
		var container := inventory.stored_containers[c].get_container()
		hover.text = container.name
		hover.mouse_entered.connect(_on_hover_mouse_entered.bind(c))

		container_tab.add_child(hover)

	set_displayed(-1, false)

func set_displayed(container:int, reset_signals:bool = true) -> void:
	if reset_signals and selected_id >= 0:
		pass
		selected.items_changed.disconnect(_container_items_changed)

	for child in item_overlay.get_children(): child.queue_free()
	for child in container_display.get_children(): child.queue_free()
	if inventory.stored_containers.is_empty() or container < 0:
		name_label.text = "None"
		selected_id = -1
		selected = null;
		return
	var con := inventory.stored_containers[container].get_container()
	name_label.text = con.name

	con.items_changed.connect(_container_items_changed)

	selected = con
	selected_id = container

	container_display.columns = con.size.x
	for i in con.size.x * con.size.y:
		var panel := Panel.new()
		panel.custom_minimum_size = Vector2(64, 64)
		panel.theme_type_variation = "GridPanel"
		container_display.add_child(panel)

	for i in con.items.size():
		var t_rect := TextureRect.new()
		var master := con.items[i].get_master()
		var rect := con.item_rects[i]
		t_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		t_rect.texture = master.inventory_icon
		t_rect.position = rect.position * 64
		t_rect.size = rect.size * 64
		item_overlay.add_child(t_rect)


func _on_hover_mouse_entered(container:int) -> void:
	set_displayed(container)

func _on_container_added(con:ContainerItem) -> void:
	print("ADDED")

	var container := con.get_container()
	displayed.append(container)

	var hover:HoverButton = HOVER_BUTTON.instantiate()
	hover.disabled = false
	hover.text = container.name
	hover.mouse_entered.connect(_on_hover_mouse_entered.bind(inventory.stored_containers.size()))

func _on_container_removed(con:ContainerItem) -> void:
	print("REMOVED")

	var container := con.get_container()
	var id := displayed.find(container)
	if id == -1:
		printerr("Could not find removed container in display")
		return

	displayed.erase(container)

	if id == selected_id:
		# the selected was removed
		set_displayed(-1)
	elif id < selected_id:
		# if removed was before, shift back one so it stays on the same one
		set_displayed(selected_id - 1)

func _container_items_changed() -> void:
	pass
