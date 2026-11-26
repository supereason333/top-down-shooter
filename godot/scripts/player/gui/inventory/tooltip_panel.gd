extends PanelContainer
class_name TooltipPanel

@onready var body_container:GridContainer = %DataDisp

@onready var name_label:Label = %NameLabel
@onready var id_label:Label = %IDLabel

## updates the display to new item
func update(item:ItemData):
	body_container.show()
	name_label.text = item.display_name
	id_label.text = item.id

## clears the displayed to display nothing
func clear():
	body_container.hide()
