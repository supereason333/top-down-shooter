# Each item has its item data, it keeps the state of the item and is the data that is stored
# when item is stored. The physical node item is only instantiated when the item is equipped
# and is freed when it is unequipped
# some things like id shouldn't be changed, use common sense or something
extends Resource
class_name ItemData

@export var display_name:String
@export var id:StringName
@export var item_scene:PackedScene
@export var inventory_icon:Texture
@export var icon_small:Texture
@export var size:Vector2i = Vector2i.ONE
@export var weight:float = 1
