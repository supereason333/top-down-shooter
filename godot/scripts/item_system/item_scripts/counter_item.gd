extends Item3D

var counter := 0

func _load_from_data(_data:ItemData):
	var data:CounterItemData = _data
	counter = data.counter

func _unload_into_data(_data:ItemData):
	var data:CounterItemData = _data
	data.counter = counter

func _item_input(event:InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			counter += 1
			print(counter)
