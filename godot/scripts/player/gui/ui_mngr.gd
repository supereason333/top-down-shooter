extends CanvasLayer
class_name UiMngr

@onready var hud:Control = $HUD
@onready var inventory:Control = %InventoryUIRoot
@onready var override_ui:Control = $OverrideUI

var controls:Array[Control]
var active:int
var default:int

func _ready() -> void:
	var children := get_children()
	for c in children.size():
		var child = children[c]
		if child is Control:
			if child == inventory:
				default = c
			child.hide()
			controls.append(child)
	set_default()

func set_active_id(id:int) -> void:
	if id < 0 or id >= controls.size(): return
	controls[active].hide()
	controls[id].show()
	active = id

func set_active_control(node:Control) -> void:
	for i in controls.size():
		if controls[i] == node:
			controls[active].hide()
			controls[i].show()
			active = i
			return

func set_default() -> void:
	if active == default: return
	controls[active].hide()
	controls[default].show()
	active = default
