class_name Player extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sens := 0.0025

@export var player_stats: PlayerStats

@onready var _camera: Camera3D = %Camera
@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _state_chart: StateChart = %StateChart
@onready var _velocity: VelocityComponent = %Velocity
@onready var _grapple_detector = %GrappleDetector
@onready var _camera_anchor = $CameraControlAnchor

func walk():
	_velocity.set_speed_modifier(0)

func sprint():
	_velocity.set_speed_modifier(player_stats.move_speed_sprint)

func jump():
	_velocity.add_impulse(Vector3.UP, player_stats.jump_velocity)

func grapple(direction: Vector3, speed: float):
	velocity = Vector3.ZERO
	_velocity.add_impulse(direction, speed)

func get_forward():
	var forward = basis.z
	forward.y = _camera_pivot.basis.z.y
	
	return forward

func get_height():
	var shape = $Shape.shape as CapsuleShape3D
	return shape.height + shape.radius * 2.0

func _ready() -> void:
	assert(player_stats, "Cannot instantiate Player without PlayerStats resource.")
	_velocity.speed = player_stats.move_speed
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event.is_action_pressed(&"ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event.is_action_pressed(&"interact"):
		_try_grapple()
		
func _try_grapple():
	var data = _grapple_detector.get_closest_grapple_point()
	if not data: return
	
	var direction = data[0]
	var distance = data[1]
	var speed = clampf(
		distance / player_stats.grapple_time,
		player_stats.min_grapple_speed,
		player_stats.max_grapple_speed
	)
	
	if direction:
		grapple(direction, speed)
		_state_chart.send_event(&"onGrapple")
