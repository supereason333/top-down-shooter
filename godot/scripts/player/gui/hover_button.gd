extends PanelContainer
class_name HoverButton

@onready var label:Label = $Label

var disabled_stylebox:StyleBox

var text:String:
	set(value):
		text = value
		if is_node_ready():
			label.text = text

var disabled:bool = false:
	set(value):
		if value == disabled: return
		disabled = value
		if is_node_ready():
			if disabled:
				label.modulate = Color(1, 1, 1, 0.5)
				mouse_filter = Control.MOUSE_FILTER_IGNORE
			else:
				label.modulate = Color(1, 1, 1, 1)
				mouse_filter = Control.MOUSE_FILTER_STOP

func _ready() -> void:
	label.text = text
	if disabled:
		label.modulate = Color(1, 1, 1, 0.5)
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		label.modulate = Color(1, 1, 1, 1)
		mouse_filter = Control.MOUSE_FILTER_STOP
