extends Item3D

func _item_input(event:InputEvent):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			Global.projectile_mngr.register_new_default("static", global_transform)
