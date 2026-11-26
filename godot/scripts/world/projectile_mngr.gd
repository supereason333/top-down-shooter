extends Node3D
class_name ProjectilesMngr

func _ready() -> void:
	pass

func register_new_default(id:StringName, projectile_transform:Transform3D) -> void:
	var new:Projectile3D = Global.projectile_lib.get_new_node(id)
	if !new: return
	new.transform = projectile_transform
	register_new_node(new)

func register_new_node(projectile:Projectile3D) -> void:
	get_tree().create_timer(projectile.lifetime).timeout.connect(projectile.queue_free)
	add_child(projectile)
