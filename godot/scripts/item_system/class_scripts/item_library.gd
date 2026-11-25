extends Resource
class_name ItemLibrary

@export var lib:Array[ItemData]

var lookup:Dictionary[StringName, ItemData]

func _init() -> void:
	print("Initializing item library")
	var start_usec := Time.get_ticks_usec()
	var seen:Array[StringName]
	for i in lib.size():
		var item := lib[i]
		if seen.has(item.id):
			printerr("Item %s seen twice" % item.id)
			continue
		lookup[item.id] = item

	var elapsed_usec := Time.get_ticks_usec() - start_usec
	print("Item library initialized in %d msecs" % (elapsed_usec / 1000.0))

func get_new(id:StringName) -> ItemData:
	var new:ItemData = lookup.get(id)
	if new:
		return new.duplicate_deep()
	return null
