extends Resource
class_name ProjectileLibrary

@export var lib:Array[ProjectileData]

var lookup:Dictionary[StringName, ProjectileData]

func initialize():
	print("Initializing projectile library")
	var start_usec := Time.get_ticks_usec()
	var seen:Array[StringName]
	var registered := 0
	for i in lib.size():
		var proj := lib[i]
		if seen.has(proj.id):
			printerr("Projectile %s seen twice" % proj.id)
			continue
		lookup[proj.id] = proj
		registered += 1

	var elapsed_usec := Time.get_ticks_usec() - start_usec

	print("Registered %d items" % registered)
	print("Projectile library initialized in %d msecs" % (elapsed_usec / 1000.0))

func get_new_node(id:StringName) -> Projectile3D:
	var new:ProjectileData = lookup.get(id)
	if new:
		return new.scene.instantiate()
	return null

func get_data(id:StringName) -> ProjectileData:
	return lookup.get(id)
