extends Camera3D

@export var target:Node3D
@export var max_follow_speed := 10.0
@export var max_distance := 10.0
@export var follow_response := 10.0

func _process(delta: float) -> void:
	var pos_err := Vector2(
		target.global_position.x,
		target.global_position.z
	) - Vector2 (
		global_position.x,
		global_position.z
	)
	var dist_err := pos_err.length()
	if dist_err > max_distance:
		var offset := pos_err.limit_length(max_distance)
		global_position = strip_y(target.global_position) - Vector3(
			offset.x,
			-global_position.y,
			offset.y
		)
		return
	var velocity := pos_err * follow_response
	self.position += (Vector3(
		velocity.x,
		0.0,
		velocity.y
	) * delta).limit_length(minf(dist_err, max_follow_speed * delta))

func strip_y(vec:Vector3) -> Vector3:
	return Vector3(
		vec.x,
		0.0,
		vec.z
	)
