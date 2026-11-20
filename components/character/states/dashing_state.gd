extends PlayerState

@onready var dash_timer: Timer = $DashTimer
var acceleration: float

func _on_dashing_state_entered() -> void:
	player._velocity.disable_interpolation = true
	acceleration = player._velocity.acceleration_coef
	player._velocity.acceleration_modifer = -acceleration * 0.7
	player._velocity.gravity_modifier = -player._velocity.gravity
	player._velocity.airborne_acceleration_factor_modifier = 1 - player._velocity.airborne_acceleration_factor
	player.stat_energy.growth_rate = player.stat_energy.max_value * player.player_stats.movement_energy_growth_factor
	dash_timer.start()

func _on_dashing_state_exited() -> void:
	player._velocity.disable_interpolation = false
	player._velocity.gravity_modifier = 0
	player._velocity.acceleration_modifer = 0
	player._velocity.airborne_acceleration_factor_modifier = 0
	
	var horizontal := Vector2(player.velocity.x, player.velocity.z)
	if horizontal.length_squared() < 0.01:
		return
	# Brake to walk speed in current direction (momentum carry)
	var brake_target := Vector3(
		horizontal.normalized().x * player.player_stats.move_speed,
		player.velocity.y,
		horizontal.normalized().y * player.player_stats.move_speed,
	)
	# Or brake to a full stop:
	# var brake_target := Vector3(0.0, player.velocity.y, 0.0)
	var brake_tween := create_tween()
	brake_tween.set_ease(Tween.EASE_OUT)
	brake_tween.set_trans(Tween.TRANS_QUAD)
	brake_tween.tween_method(player._velocity.set_velocity, player.velocity, brake_target, 0.1)

func _on_dash_timer_timeout() -> void:
	player.state_chart.send_event(&"onNormal")
