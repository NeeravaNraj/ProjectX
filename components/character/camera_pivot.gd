extends Node3D

@onready var player = $".."

var mouse_input = Vector2.ZERO
var current_rotation = Vector3.ZERO

func _ready():
	current_rotation = player.rotation

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and 
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	
	if is_camera_motion:
		mouse_input += event.screen_relative * player.mouse_sens

	
func  _process(_delta: float):
	current_rotation.x = clamp(current_rotation.x - mouse_input.y, deg_to_rad(-80), deg_to_rad(90))
	current_rotation.y -= mouse_input.x
	
	var camera_anchor = player._camera_anchor
	var pitch = Vector3(current_rotation.x, 0.0, 0.0)
	var yaw = Vector3(0.0, current_rotation.y, 0.0)
	
	rotation = pitch + yaw
	player.global_transform.basis = Basis.from_euler(yaw)
	
	global_position = camera_anchor.get_global_transform_interpolated().origin
	
	mouse_input = Vector2.ZERO
