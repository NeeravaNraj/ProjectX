class_name Player extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sens := 0.0025

@export_group("Movement")
@export var sprint_speed := 4
@export var jump_power := 10.0

@onready var _camera: Camera3D = %Camera
@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _velocity: VelocityComponent = %Velocity
@onready var _state_chart: StateChart = %StateChart

var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and 
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)

	if is_camera_motion:
		rotation.y -= event.relative.x * mouse_sens
		_camera_pivot.rotation.x += -event.relative.y * mouse_sens
		_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, deg_to_rad(-80), deg_to_rad(90))

func walk():
	_velocity.set_speed_modifier(0)

func sprint():
	_velocity.set_speed_modifier(sprint_speed)

func jump():
	_velocity.add_impulse(Vector3.UP, jump_power)

	
	
	
	
	
	
