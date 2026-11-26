extends Resource
class_name ItemFilter

enum ItemTags {
	CONSUMABLE,			# consumable like food or ammo
	FUNCTIONAL,			# tool or weapon, can be used in hands
	EQUIPPABLE_HEAD,	# armour and stuff
	EQUIPPABLE_TORSO,
	EQUIPPABLE_HIP,
	EQUIPPABLE_LEG,
	EQUIPPABLE_FOOT
}

func filter(id:StringName) -> bool:
	return true
