extends PanelContainer
class_name EqippedGrid

@onready var grid_panel:GridContainer = $Grid
@onready var single_panel:Panel = $Single
@onready var texture:TextureRect = $Texture
@onready var mouse_catcher:Control = $MouseCatcher
@onready var equipped_marker:Panel = $EquipMarker

var grid_size:Vector2i

func _ready() -> void:
	@warning_ignore("integer_division")
	grid_size = Vector2i(
		grid_panel.columns,
		grid_panel.get_child_count() / grid_panel.columns
	)
