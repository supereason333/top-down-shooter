# Item that is instantiated when an item is equipped
extends Node3D
class_name Item3D

## When first instantiated, loads state
func load_from_data(data:ItemData):
	pass

## When unloaded, stores state
func unload_into_data(data:ItemData):
	pass
