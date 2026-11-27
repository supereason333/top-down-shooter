extends Resource
class_name ItemLibrary

@export var lib:Dictionary[ItemMasterData, ItemData]

var master_lookup:Dictionary[StringName, ItemMasterData]
var lookup:Dictionary[StringName, ItemData]

func initialize():
	pass
	print("Initializing item library")
	var start_usec := Time.get_ticks_usec()
	var seen:Array[StringName]
	var registered := 0
	for master in lib.keys():
		var item := lib[master]
		if seen.has(master.id):
			printerr("Item %s seen twice" % item.id)
			continue
		item.id = master.id
		# lookup[master.id] = item
		lookup.set(master.id, item)
		# master_lookup[master.id] = master
		master_lookup.set(master.id, master)
		registered += 1

	var elapsed_usec := Time.get_ticks_usec() - start_usec

	print("Registered %d items" % registered)
	print("Item library initialized in %d msecs" % (elapsed_usec / 1000.0))

func get_new(id:StringName) -> ItemData:
	var base:ItemData = lookup.get(id)
	if !base: return null
	var new:ItemData = base.duplicate_deep()
	new.item_initialize()
	return new

func get_master(id:StringName) -> ItemMasterData:
	return master_lookup.get(id)
