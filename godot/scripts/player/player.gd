extends RigidBody3D
class_name Player

@onready var player_rotate:Node3D = $Rotate

@export var sens := 0.001
@export var walk_speed := 10.0
@export var sprint_speed := 15.0
@export var response := 10.0
@export var max_force := 600.0

var pos_reset_queued := false
var reset_pos:Vector2

func _physics_process(_dt: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var target_speed := sprint_speed if Input.is_action_pressed("sprint") else walk_speed
	var target_velocity := Vector3 (
		input_dir.x,
		0.0,
		input_dir.y
	) * target_speed

	var velocity_error := target_velocity - linear_velocity

	apply_central_force((velocity_error * response * mass).limit_length(max_force))
