extends Node

@export var item_lib:ItemLibrary
@export var projectile_lib:ProjectileLibrary

var world:World
var projectile_mngr:ProjectilesMngr

func _ready() -> void:
	item_lib.initialize()
	projectile_lib.initialize()
