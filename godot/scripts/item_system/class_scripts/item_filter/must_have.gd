extends ItemFilter
class_name MustHaveFilter

@export var params:Array[ItemTags]

## Item must have every tag specified
func filter(id:StringName) -> bool:
	var master := Global.item_lib.get_master(id)
	if !master: return false
	for tag in params:
		if !master.tags.has(tag): return false
	return true
