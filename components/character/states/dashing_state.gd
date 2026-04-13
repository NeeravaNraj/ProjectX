extends PlayerState

@onready var dash_timer: Timer = $DashTimer
var acceleration: float

func _on_dashing_state_entered() -> void:
	acceleration = player._velocity.acceleration_coef
	player._velocity.acceleration_modifer = -acceleration * 0.7
	player._velocity.gravity_modifier = -player._velocity.gravity
	player._velocity.airborne_acceleration_factor_modifier = 1 - player._velocity.airborne_acceleration_factor
	player.stat_energy.growth_rate = player.stat_energy.max_value * player.player_stats.movement_energy_growth_factor
	dash_timer.start()

func _on_dashing_state_exited() -> void:
	player._velocity.gravity_modifier = 0
	player._velocity.acceleration_modifer = 0
	player._velocity.airborne_acceleration_factor_modifier = 0

func _on_dash_timer_timeout() -> void:
	player.state_chart.send_event(&"onNormal")
