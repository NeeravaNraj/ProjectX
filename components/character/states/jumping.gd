extends PlayerState

@onready var jump_timer: Timer = $JumpTimer 


func _on_jumping_state_entered() -> void:
	if jump_timer.is_stopped(): jump_timer.stop()
	var jump_energy_growth_factor = stats.get_computed_stat(player.stat_ident.JumpEnergyGrowthFactor)

	jump_timer.start()
	player._velocity.gravity_modifier = 0.0
	player.stat_energy.growth_rate = player.stat_energy.max_value * jump_energy_growth_factor

func _on_jump_timer_timeout() -> void:
	if not player: return 
	player.state_chart.send_event(&"onFalling")

func _on_jumping_state_exited() -> void:
	jump_timer.stop()
