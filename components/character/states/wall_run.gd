extends PlayerState

const TILT_ANGLE := 5.0

var wall_normal := Vector3.ZERO
var wall_run_perpendicular = 0.0

func _on_wall_running_state_entered() -> void:
	player._velocity.set_gravity_modifier(-player._velocity.gravity)
	_reset_velocity()
	player.camera_pivot.block_movement_tilt = true
	player.fp_rig.transition_movement(PlayerFirstPersonRig.MovementStates.Running)

func _on_wall_running_state_exited() -> void:
	player._velocity.set_gravity_modifier(0.0)
	player.camera_pivot.block_movement_tilt = false

func _on_wall_running_state_physics_processing(delta: float) -> void:
	_check_can_wall_run()
	_reset_velocity()
	_lerp_camera_tilt(delta)
	player.sprint()

func _on_wall_running_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		_jump_from_wall_run()

func _jump_from_wall_run():
	var direction = -player.get_forward()
	direction += player.get_wall_normal()
	direction.y = clamp(player.camera_pivot.get_pitch() * 0.2, 0.25, 0.8)
	direction *= player.player_stats.wall_run_jump_velocity
	
	var original_decel = player._velocity.deceleration_coef
	player._velocity.deceleration_coef = 0.01
	
	var wall_jump_decel_tween = create_tween()
	var wall_jump_velocity_tween = create_tween()
	wall_jump_decel_tween.set_ease(Tween.EASE_IN)
	wall_jump_decel_tween.tween_property(player._velocity, "deceleration_coef", original_decel, 1.0)
	wall_jump_velocity_tween.tween_method(player._velocity.set_velocity, player.velocity, direction, 0.075)
	
func _lerp_camera_tilt(delta: float):
	var wall_tangent = Vector3(-wall_normal.z, 0.0, wall_normal.x)
	var lean_direction = wall_tangent.dot(player.get_forward())
	
	var angle = TILT_ANGLE
	if lean_direction > 0: angle *= -1
	
	player.camera_pivot.target_camera_tilt = deg_to_rad(angle)

func _check_can_wall_run():
	var forward = player.get_forward()
	wall_run_perpendicular = forward.dot(wall_normal)
	
	if !(wall_run_perpendicular >= -0.7 and wall_run_perpendicular <= 0.6):
		player.state_chart.send_event(&"onFalling")
	
	if not player.is_on_wall():
		player.state_chart.send_event(&"onFalling")

func _reset_velocity():
	wall_normal = player.get_wall_normal()
	player.velocity.y = 0.0
	player.velocity = player.transform.basis.z * -player.player_stats.move_speed * 2
	player.velocity = player.velocity.slide(wall_normal)
	player.velocity += -wall_normal * (player.player_stats.move_speed / 2)
	player._velocity.set_velocity(player.velocity)
