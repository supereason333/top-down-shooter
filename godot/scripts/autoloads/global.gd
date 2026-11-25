extends Node

@export var item_lib:ItemLibrary

func _ready() -> void:
	item_lib.initialize()
