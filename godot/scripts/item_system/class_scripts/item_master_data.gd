# its like item data but like unmutable, its a master refrence for everything
extends Resource
class_name ItemMasterData

@export var id:StringName
@export var item_scene:PackedScene
@export var inventory_icon:Texture
@export var icon_small:Texture
@export var size:Vector2i = Vector2i.ONE
@export var tags:Array[ItemFilter.ItemTags]	# tells what the actual instantiated item does
