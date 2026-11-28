extends VBoxContainer

signal item_equipped(slot:int, item:ItemData)
signal item_unequipped(slot:int)

# primary, secondary, quick use 1, 2, 3
@export var equipped_slots:Array[EqippedGrid]
@export var filters:Array[ItemFilter]

@onready var root:InventoryUI = %InventoryUIRoot
@onready var inventory:PlayerInventory = %Inventory
@onready var tooltip:TooltipPanel = $"../../TooltipPanel"

var equipped:Array[ItemData]

func _ready() -> void:
	equipped.resize(5)
	for i in equipped_slots.size():
		equipped_slots[i].mouse_catcher.gui_input.connect(_slot_gui_input.bind(i))
		equipped_slots[i].mouse_catcher.mouse_entered.connect(display_tooltip.bind(i))
		equipped_slots[i].mouse_catcher.mouse_exited.connect(hide_tooltip)

func _slot_gui_input(event:InputEvent, slot:int):
	if event is InputEventMouseButton:
		if root.current_held and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# clicked when dropping
			if filters[slot].filter(root.current_held.id) and !equipped[slot]:
				equip_item(slot, root.take_drag_item())
				display_tooltip(slot)

		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# clicked to get item
			if equipped[slot]:
				if root.request_drag(equipped[slot]):
					unequip_item(slot)
					display_tooltip(slot)

func equip_item(slot:int, item:ItemData):
	equipped[slot] = item
	var master := item.get_master()
	equipped_slots[slot].single_panel.show()
	equipped_slots[slot].texture.show()
	equipped_slots[slot].texture.texture = master.inventory_icon
	equipped_slots[slot].texture.custom_minimum_size = master.size * 64

	item_equipped.emit(slot, item)

func unequip_item(slot:int):
	equipped[slot] = null
	equipped_slots[slot].single_panel.hide()
	equipped_slots[slot].texture.hide()

	item_unequipped.emit(slot)

func display_tooltip(slot:int):
	tooltip.show()
	if equipped[slot]:
		tooltip.update(equipped[slot])
	else:
		tooltip.clear()

func hide_tooltip():
	tooltip.hide()

##### below is like more specific stuff above is like only array stuff
