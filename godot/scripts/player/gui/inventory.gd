extends Control

@onready var inv := PlayerInventory

func _ready() -> void:
	get_tree().root.content_scale_factor = 1.0
