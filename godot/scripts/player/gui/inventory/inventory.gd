extends Control
class_name InventoryUI

# func _ready() -> void:
# 	get_tree().root.content_scale_factor = 1.0

signal drag_started(item:ItemData)
signal drag_finished

@onready var inventory:PlayerInventory = %Inventory

@onready var drag_disp:TextureRect = $DragItemDisplay

var current_held:ItemData

func _process(_delta: float) -> void:
	if current_held:
		drag_disp.position = get_local_mouse_position() - Vector2(32, 32)

# requests a drag in the inventory, if successful caller should remove item from
# inventory else dont
func request_drag(item:ItemData) -> bool:
	if current_held: return false
	drag_disp.show()
	var master := item.get_master()
	drag_disp.texture = master.inventory_icon
	drag_disp.size = master.size * 64
	current_held = item
	drag_started.emit(item)
	return true

func take_drag_item() -> ItemData:
	if !current_held: return null
	drag_disp.hide()
	var held := current_held
	current_held = null
	drag_finished.emit()
	return held
