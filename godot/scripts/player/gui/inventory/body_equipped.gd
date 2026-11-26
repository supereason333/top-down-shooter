extends VBoxContainer

const HOVER_BUTTON:PackedScene = preload("uid://osckj4xj15i")

@onready var inventory:PlayerInventory = %Inventory

@onready var part_tab:HBoxContainer = $PartTab
@onready var name_label:Label = $NameLabel
@onready var container_display:GridContainer = $ClearPanel/ContainerDisplay
@onready var item_overlay:Control = $ClearPanel/ItemOverlay

var current_container:int = 0

func _ready() -> void:
	for child in part_tab.get_children(): child.queue_free()
	for child in container_display.get_children(): child.queue_free()
	for child in item_overlay.get_children(): child.queue_free()
	for c in inventory.body_containers.size():
		var hover:HoverButton = HOVER_BUTTON.instantiate()
		hover.disabled = false
		hover.text = inventory.body_containers[c].name
		hover.mouse_entered.connect(_on_hover_mouse_entered.bind(c))

		part_tab.add_child(hover)

	set_displayed(0, false)

func set_displayed(container:int, reset_signals:bool = true) -> void:
	var con := inventory.body_containers[current_container]
	if reset_signals:
		con.items_changed.disconnect(_container_items_changed)
	current_container = container
	con = inventory.body_containers[current_container]
	con.items_changed.connect(_container_items_changed)

	name_label.text = con.name
	container_display.columns = con.size.x
	for child in container_display.get_children(): child.queue_free()
	for child in item_overlay.get_children(): child.queue_free()
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


func _container_items_changed() -> void:
	pass

func _on_hover_mouse_entered(container:int) -> void:
	set_displayed(container)
