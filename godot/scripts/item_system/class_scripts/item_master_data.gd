# its like item data but like unmutable, its a master refrence for everything
extends Resource
class_name ItemMasterData

enum ItemTags {
	CONSUMABLE,			# consumable like food or ammo
	FUNCTIONAL,			# tool or weapon, can be used in hands
	EQUIPPABLE_HEAD,	# armour and stuff
	EQUIPPABLE_TORSO,
	EQUIPPABLE_HIP,
	EQUIPPABLE_LEG,
	EQUIPPABLE_FOOT
}

@export var id:StringName
@export var item_scene:PackedScene
@export var inventory_icon:Texture
@export var icon_small:Texture
@export var size:Vector2i = Vector2i.ONE
@export var tags:Array[ItemTags]	# tells what the actual instantiated item does
