class_name Player extends CharacterBody3D

@export var player_stats: PlayerStats

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sens := 0.0025

@onready var camera: Camera3D = %Camera
@onready var camera_pivot: Node3D = %CameraPivot
@onready var grapple_detector = %GrappleDetector
@onready var camera_anchor = $CameraControlAnchor
@onready var fp_rig = $CameraPivot/FirstPersonRig
@onready var state_chart: StateChart = %StateChart
@onready var debug_gui = $CanvasLayer/StateChartDebugger
@onready var shuriken_ctrl = $ShurikenCtrl

@onready var _velocity: VelocityComponent = %Velocity

var space_state: PhysicsDirectSpaceState3D
var shuriken_scene = preload("res://components/shuriken/shuriken.tscn")

signal grappled()

func walk():
	_velocity.set_speed_modifier(0)

func sprint():
	_velocity.set_speed_modifier(player_stats.move_speed)

func dash():
	_velocity.add_impuse_in_move_direction(player_stats.move_speed_dash)

func jump():
	_velocity.add_impulse(Vector3.UP, player_stats.jump_velocity)

func grapple(direction: Vector3, speed: float):
	velocity = Vector3.ZERO
	_velocity.add_impulse(direction, speed)

func get_forward():
	return camera.global_transform.basis.z.normalized()

func get_height():
	var shape = $Shape.shape as CapsuleShape3D
	return shape.height + shape.radius * 2.0

func add_item(node: Node3D):
	shuriken_ctrl.pickup_shuriken(node as Shuriken)

func _ready() -> void:
	assert(player_stats, "Cannot instantiate Player without PlayerStats resource.")
	space_state = get_world_3d().direct_space_state
	_velocity.speed = player_stats.move_speed
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event.is_action_pressed(&"ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event.is_action_pressed(&"shuriken"):
		shuriken_ctrl.throw_shuriken()
	
	if event.is_action_pressed(&"interact"):
		_try_grapple()

func _try_grapple():
	var override_max = 50
	var override_min = 0
	
	var data = shuriken_ctrl.get_grapple_location()
	
	if not data:
		data = grapple_detector.get_closest_grapple_point()
		override_max = player_stats.max_grapple_speed
		override_min = player_stats.min_grapple_speed
	
	if not data: return
	
	var direction = data[0]
	var distance = data[1]
	var speed = clampf(
		distance / player_stats.grapple_time,
		override_min,
		override_max,
	)
	
	if direction and distance >= 5:
		grapple(direction, speed)
		await get_tree().create_timer(0.015).timeout
		grappled.emit()
		state_chart.send_event.call_deferred(&"onGrapple")
