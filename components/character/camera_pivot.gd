extends Node3D

@onready var player = $".."

const MAX_TILT_ANGLE := deg_to_rad(5.0)

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

	
func  _physics_process(_delta: float):
	current_rotation.x = clamp(current_rotation.x - mouse_input.y, deg_to_rad(-80), deg_to_rad(90))
	current_rotation.y -= mouse_input.x
	
	var pitch = Vector3(current_rotation.x, 0.0, 0.0)
	var yaw = Vector3(0.0, current_rotation.y, 0.0)
	
	rotation = pitch
	player.global_transform.basis = Basis.from_euler(yaw)
	
	mouse_input = Vector2.ZERO
	
	_tilt_camera()
	
func _tilt_camera():
	var move_direction = player._velocity.raw_direction
	var side = Vector3.FORWARD * (MAX_TILT_ANGLE * move_direction.x)
	var forward = Vector3.RIGHT * ((MAX_TILT_ANGLE / 2.0) * move_direction.y)
	var rot = forward + side
	
	var tween = create_tween()
	tween.tween_property(player.camera, "rotation", rot, 0.3)
