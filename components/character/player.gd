extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sens := 0.75

@export_group("Movement")
@export var jump_power := 10.0

@onready var _camera: Camera3D = %Camera
@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _velocity: VelocityComponent = %Velocity

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
		_camera_input_direction = event.screen_relative * mouse_sens
		
func _physics_process(delta: float) -> void:
	_camera_pivot.rotation.x += -_camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, deg_to_rad(-80), deg_to_rad(90))
	rotation.y -= _camera_input_direction.x * delta
	
	_camera_input_direction = Vector2.ZERO
	
	var is_starting_jump := Input.is_action_just_pressed("jump") and is_on_floor()
	if is_starting_jump:
		_velocity.add_impulse(Vector3.UP, jump_power)
	move_and_slide()
	
	
	
	
	
	
	
