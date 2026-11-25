extends Node3D

func _raycast_collision_changed(pos: Vector3) -> void:
	rotation.y = -Vector2(
		global_position.x,
		global_position.z
	).angle_to_point(Vector2(
		pos.x,
		pos.z
	)) - PI/2
