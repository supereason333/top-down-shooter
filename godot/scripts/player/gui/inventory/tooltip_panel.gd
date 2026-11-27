extends PanelContainer
class_name TooltipPanel

@onready var body_container:GridContainer = %DataDisp

@onready var name_label:Label = %NameLabel
@onready var id_label:Label = %IDLabel
@onready var mass_label:Label = %MassLabel

## updates the display to new item
func update(item:ItemData):
	body_container.show()
	name_label.text = item.display_name
	id_label.text = item.id
	var mass:float = item.net_mass if item is ContainerItem else item.mass
	if item is ContainerItem:

		print(item.net_mass)
	mass_label.text = "%s Kg" % (item.net_mass if item is ContainerItem else item.mass)

## clears the displayed to display nothing
func clear():
	body_container.hide()
