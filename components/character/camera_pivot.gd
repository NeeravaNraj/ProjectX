extends Node3D

@onready var player = $".."

const MAX_TILT_ANGLE := deg_to_rad(2.5)

var mouse_input = Vector2.ZERO
var current_rotation = Vector3.ZERO

var target_camera_tilt := 0.0
var block_movement_tilt = false

func get_pitch():
	return rad_to_deg(current_rotation.x)

func _ready():
	current_rotation = player.rotation

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and 
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	
	if is_camera_motion:
		mouse_input += event.screen_relative * player.mouse_sens

	
func  _physics_process(delta: float):
	current_rotation.x = clamp(current_rotation.x - mouse_input.y, deg_to_rad(-80), deg_to_rad(90))
	current_rotation.y -= mouse_input.x
	
	var pitch = Vector3(current_rotation.x, 0.0, 0.0)
	var yaw = Vector3(0.0, current_rotation.y, 0.0)
	
	rotation = pitch
	player.global_transform.basis = Basis.from_euler(yaw)
	
	mouse_input = Vector2.ZERO
	
	if block_movement_tilt:
		player.camera.rotation.z = lerp(player.camera.rotation.z, target_camera_tilt, delta * 12.0)
	
	_tilt_camera_from_movement(delta)
	
func _tilt_camera_from_movement(delta: float):
	if block_movement_tilt: return
	var move_direction = player._velocity.raw_direction
	var side = Vector3.FORWARD * (MAX_TILT_ANGLE * move_direction.x)
	var forward = Vector3.RIGHT * ((MAX_TILT_ANGLE / 2.0) * move_direction.y)
	var rot = forward + side
	
	player.camera.rotation = player.camera.rotation.lerp(rot, delta * 6.0)
