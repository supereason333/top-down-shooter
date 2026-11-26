extends Node3D
class_name World

@onready var projectile_mngr:ProjectilesMngr = $ProjectilesMngr

func _ready() -> void:
	Global.world = self
	Global.projectile_mngr = projectile_mngr
