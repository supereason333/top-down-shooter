extends VBoxContainer

signal item_added(slot:int, item:ItemData)
signal item_removed(slot:int)

# primary, secondary, quick use 1, 2, 3
@export var display_slots:Array[EqippedGrid]
@export var filters:Array[ItemFilter]

@onready var root:InventoryUI = %InventoryUIRoot
@onready var inventory:PlayerInventory = %Inventory
@onready var tooltip:TooltipPanel = $"../../TooltipPanel"
@onready var item_equip:ItemEquip = %ItemEquip

var items:Array[ItemData]

func _ready() -> void:
	item_equip.remove_unblocked.connect(_on_can_unequip)
	equipped_changed.connect(_on_equipped_changed)
	item_added.connect(_on_item_added)
	item_removed.connect(_on_item_removed)

	items.resize(5)
	for i in display_slots.size():
		display_slots[i].mouse_catcher.gui_input.connect(_slot_gui_input.bind(i))
		display_slots[i].mouse_catcher.mouse_entered.connect(display_tooltip.bind(i))
		display_slots[i].mouse_catcher.mouse_exited.connect(hide_tooltip)

	await get_tree().process_frame
	await get_tree().process_frame

	equip_slot(0)

func _slot_gui_input(event:InputEvent, slot:int):
	if event is InputEventMouseButton:
		if root.current_held and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# clicked when dropping
			if filters[slot].filter(root.current_held.id) and !items[slot]:
				add_item(slot, root.take_drag_item())
				display_tooltip(slot)

		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# clicked to get item
			if items[slot]:
				if root.request_drag(items[slot]):
					remove_item(slot)
					display_tooltip(slot)

func add_item(slot:int, item:ItemData):
	items[slot] = item
	var master := item.get_master()
	display_slots[slot].single_panel.show()
	display_slots[slot].texture.show()
	display_slots[slot].texture.texture = master.inventory_icon
	display_slots[slot].texture.custom_minimum_size = master.size * 64

	item_added.emit(slot, item)

func remove_item(slot:int) -> bool:
	if equipped_slot == slot:
		if !item_equip.can_unequip(): return false

	items[slot] = null
	display_slots[slot].single_panel.hide()
	display_slots[slot].texture.hide()

	item_removed.emit(slot)
	return true

#its like the equip item but it actually takes the item
func take_slot(slot:int) -> ItemData:
	if items[slot]:
		if equipped_slot == slot:
			if !item_equip.can_unequip(): return null

		var item := items[slot]
		remove_item(slot)
		return item
	return null

func display_tooltip(slot:int):
	tooltip.show()
	if items[slot]:
		tooltip.update(items[slot])
	else:
		tooltip.clear()

func hide_tooltip():
	tooltip.hide()

##### below is like the equipped stuff like equipping primary etc

signal equipped_changed(slot:int)
signal queued_equip(slot:int)

var equipped_slot := 0
var queued_equip_slot := -1

func equip_slot(slot:int):
	if item_equip.equip_item(items[slot]):
		equipped_changed.emit(slot)
		equipped_slot = slot
	else:
		queued_equip_slot = slot
		queued_equip.emit(slot)

func _on_can_unequip():
	if queued_equip_slot < 0: return
	item_equip.force_equip(items[queued_equip_slot])
	equipped_changed.emit(queued_equip_slot)
	equipped_slot = queued_equip_slot
	queued_equip_slot = -1

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("equip_primary") and equipped_slot != 0:
		equip_slot(0)
	if event.is_action_pressed("equip_secondary") and equipped_slot != 1:
		equip_slot(1)
	if event.is_action_pressed("equip_3") and equipped_slot != 2:
		equip_slot(2)
	if event.is_action_pressed("equip_4") and equipped_slot != 3:
		equip_slot(3)
	if event.is_action_pressed("equip_5") and equipped_slot != 4:
		equip_slot(4)

func _on_equipped_changed(slot:int) -> void:
	for i in display_slots.size():
		if i == slot: display_slots[i].equipped_marker.show()
		else: display_slots[i].equipped_marker.hide()

func _on_item_added(slot:int, _item:ItemData) -> void:
	if slot == equipped_slot:
		equip_slot(slot)

func _on_item_removed(slot:int) -> void:
	if slot == equipped_slot:
		item_equip.force_unequip()
