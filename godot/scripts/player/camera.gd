extends Camera3D

signal raycast_collision_updated(pos:Vector3)

@export var target:Node3D
@export var max_follow_speed := 10.0
@export var max_distance := 10.0
@export var follow_response := 10.0

@onready var mouse_raycast:RayCast3D = $MouseRay
@onready var mouse_marker:Node3D = $MouseMarker

var mouse_raycast_depth := 10.0
var viewport_size:Vector2i
var view_depth:float = 0.0

func _ready() -> void:
	get_viewport().size_changed.connect(_viewport_size_changed)
	_viewport_size_changed()

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

func _viewport_size_changed() -> void:
	viewport_size = get_viewport().get_visible_rect().size
	view_depth = (viewport_size.y / 2.0) / tan(deg_to_rad(fov) / 2)

func _physics_process(_delta: float) -> void:
	if mouse_raycast.get_collider():
		mouse_marker.visible = true
		var collision_pos := mouse_raycast.get_collision_point()
		raycast_collision_updated.emit(collision_pos)
		mouse_marker.global_position = collision_pos
	else:
		mouse_marker.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var d:Vector2 = event.position - viewport_size / 2.0
		var pos:Vector2 = (Vector2(d.x, d.y) / view_depth) * mouse_raycast_depth

		mouse_raycast.target_position = Vector3(
			pos.x,
			-mouse_raycast_depth,
			pos.y
		)
