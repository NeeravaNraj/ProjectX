class_name Player extends CharacterBody3D


@export var player_stats: PlayerStats

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sens := 0.0025

@onready var camera: Camera3D = %Camera
@onready var camera_pivot: Node3D = %CameraPivot
@onready var grapple_detector = %GrappleDetector
@onready var camera_anchor = $CameraControlAnchor
@onready var fp_rig = $CameraPivot/Camera/FirstPersonRig
@onready var state_chart: StateChart = %StateChart
@onready var debug_gui = $UI/StateChartDebugger
@onready var shuriken_ctrl = $ShurikenCtrl
@onready var stat_energy: GrowingStatComponent = $Stats/Energy
@onready var stat_momentum: GrowingStatComponent = $Stats/Momentum
@onready var hurt_box: HurtBox = $Areas/HurtBox
@onready var weaponry = $WeaponCtrl

@onready var debug_tracker := %DebugTracker
@onready var _health: Health = $Stats/Health
@onready var _velocity: VelocityComponent = %Velocity
@onready var stats: StatsComponent = %StatsComponent
@onready var velocity_component: VelocityComponent = _velocity

const stat_ident = StatsComponent.StatIdent
var INTERACTABLE_MASK = Utils.get_collition_layer_by_name("Interactable")

var spawn_point = Vector3.ZERO
var space_state: PhysicsDirectSpaceState3D
var shuriken_scene = preload("res://components/shuriken/shuriken.tscn")

signal grappled()

func sprint():
	var value = stats.get_computed_stat(stat_ident.MoveSpeed)
	_velocity.set_speed(value)

func dash():
	var raw_direction = _velocity.raw_direction
	var pitch = camera_pivot.current_rotation.x / 1.6
	pitch = clamp(pitch, -0.2, 0.2)
	var direction = transform.basis * Vector3(raw_direction.x, pitch, raw_direction.y)
	
	if is_on_floor():
		var floor_normal = get_floor_normal()
		direction = direction.slide(floor_normal).normalized()
	
	var value = stats.get_computed_stat(stat_ident.DashMoveSpeed)
	_velocity.set_velocity(direction * value)

func jump():
	var value = stats.get_computed_stat(stat_ident.JumpVelocity)
	_velocity.add_impulse(Vector3.UP, value)

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
	spawn_point = global_position
	_velocity.speed = stats.get_computed_stat(stat_ident.MoveSpeed)

func _physics_process(_delta: float) -> void:
	debug_tracker.track(&"Energy", stat_energy.value)
	debug_tracker.track(&"Latent momentum", stat_momentum.value)
	debug_tracker.track(&"Velocity", velocity)
	debug_tracker.track(&"Deceleration", _velocity.deceleration_coef)

	_velocity.set_speed_modifier(stat_energy.value * 0.5)
	_velocity.deceleration_coef = _velocity.get_speed() * 2
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event.is_action_pressed(&"ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event.is_action_pressed(&"shuriken"):
		shuriken_ctrl.throw_shuriken()

	if event.is_action_pressed(&"interact"):
		_interact()
	
	if event.is_action_pressed(&"boost"):
		enter_boost()
	
	if event.is_action_pressed(&"left_click"):
		weaponry.attack()
	
	if event.is_action_pressed(&"dash"):
		dash()
		state_chart.send_event(&"onDashing")

func _interact():
	var size = Vector3(2.0, 1, 2.0)
	var center = Vector3(0.0, 0.3, -(1.3 + size.z * 0.5))
	var query_transform = camera_pivot.global_transform.translated_local(center)
	var targets = PhysicsUtils.query_box_collision(space_state, query_transform, size, INTERACTABLE_MASK)
	
	for target in targets:
		if target.is_in_group(&"loot_crate"):
			_open_loot_crate(target as LootCrate)
			return
	
	_try_grapple()


func _open_loot_crate(target: LootCrate):
	if target == null: return
	target.open()


func _try_grapple():
	var override_max = 50
	var override_min = 0

	var data = shuriken_ctrl.get_grapple_location()

	if not data:
		data = grapple_detector.get_closest_grapple_point()
		override_max = stats.get_base_value(stat_ident.MaxGrappleSpeed)
		override_min = stats.get_base_value(stat_ident.MinGrappleSpeed)

	if not data: return
	
	var direction = data[0]
	var distance = data[1]
	var speed = clampf(
		distance / stats.get_base_value(stat_ident.GrappleTime),
		override_min,
		override_max,
	)

	if direction and distance >= 5:
		grapple(direction, speed)
		await get_tree().create_timer(0.015).timeout
		grappled.emit()
		state_chart.send_event.call_deferred(&"onGrapple")

func enter_boost():
	var boost_energy_growth_factor = stats.get_computed_stat(stat_ident.BoostEnergyGrowthFactor)
	var boost_momentum_growth_factor = stats.get_computed_stat(stat_ident.BoostMomentumGrowthFactor)

	stat_energy.growth_rate_modifier = stat_energy.max_value * boost_energy_growth_factor
	stat_momentum.growth_rate = stat_momentum.max_value * boost_momentum_growth_factor
	stat_momentum.allow_growth = true

func exit_boost():
	stat_energy.growth_rate_modifier = 0.0
	stat_momentum.allow_growth = false

func _on_momentum_reached_min(_value: float) -> void:
	exit_boost()

func _on_health_death() -> void:
	global_position = spawn_point
	_health.reset()
	print("YOU DIED!")
