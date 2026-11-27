extends VBoxContainer

const HOVER_BUTTON:PackedScene = preload("uid://osckj4xj15i")

@onready var root:InventoryUI = %InventoryUIRoot
@onready var inventory:PlayerInventory = %Inventory
@onready var tooltip:TooltipPanel = $HBox/TooltipPanel

@onready var container_display:GridContainer = $HBox/ClearPanel/ContainerDisplay
@onready var item_overlay:Control = $HBox/ClearPanel/ItemOverlay
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

	root.drag_started.connect(_on_drag_started)
	root.drag_finished.connect(_on_drag_finished)

	for item in inventory.stored_containers:
		displayed.append(item.get_container())

	update_hover_buttons()

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

	update_items()
	mouse_grid_pos = Vector2i(-1, -1)

func _on_hover_mouse_entered(container:int) -> void:
	set_displayed(container)

func _on_container_added(con:ContainerItem) -> void:
	var container := con.get_container()
	displayed.append(container)

	update_hover_buttons()

func _on_container_removed(con:ContainerItem) -> void:
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

	update_hover_buttons()

# update items
func _container_items_changed() -> void:
	for child in item_overlay.get_children(): child.queue_free()
	update_items()
	update_under_mouse()

func update_items():
	var con := inventory.stored_containers[selected_id].get_container()
	for i in con.items.size():
		var t_rect := TextureRect.new()
		var master := con.items[i].get_master()
		var rect := con.item_rects[i]
		t_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		t_rect.texture = master.inventory_icon
		t_rect.position = rect.position * 64
		t_rect.size = rect.size * 64
		item_overlay.add_child(t_rect)

func update_hover_buttons():
	for child in container_tab.get_children(): child.queue_free()
	var can_drop:Array[int]
	for c in inventory.stored_containers.size():
		var hover:HoverButton = HOVER_BUTTON.instantiate()
		hover.disabled = false
		var container := inventory.stored_containers[c].get_container()
		hover.text = container.name
		hover.mouse_entered.connect(_on_hover_mouse_entered.bind(c))

		if root.current_held:
			if !inventory.stored_containers[c].get_container().can_add(root.current_held):
				hover.disabled = true
			else:
				can_drop.append(c)

		container_tab.add_child(hover)

	if root.current_held:
		if can_drop.is_empty():
			set_displayed(-1)
		elif !can_drop.has(selected_id):
			set_displayed(can_drop[0])
	# if root.current_held:
	# 	pass
	# else:


func _on_drag_started(_item:ItemData):
	update_hover_buttons()

func _on_drag_finished():
	update_hover_buttons()




var mouse_grid_pos:Vector2i = Vector2i(-1, -1)

# check which is pressed and do stuff
func _mouse_catcher_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var new_pos:Vector2i = to_grid(event.position)

		if mouse_grid_pos != new_pos:
			mouse_grid_pos = new_pos
			update_under_mouse()
	elif event is InputEventMouseButton:
		if root.current_held:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				var grid := to_grid(event.position)
				if inventory.add_container_item_at(root.current_held, selected_id, grid):
					root.take_drag_item()
		else:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				var grid := to_grid(event.position)
				var item := inventory.get_container_item(selected_id, grid)
				if !item: return
				if root.request_drag(item):
					inventory.remove_container_item(selected_id, grid)

# when mouse moves, it updates the tooltip and stuff
func update_under_mouse():
	var item := inventory.get_container_item(selected_id, mouse_grid_pos)
	if item:
		tooltip.update(item)
	else:
		tooltip.clear()

func to_grid(local:Vector2) -> Vector2i:
	@warning_ignore("integer_division")
	return Vector2i(local) / 64
