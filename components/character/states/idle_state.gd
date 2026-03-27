extends PlayerState


func _on_idle_state_physics_processing(_delta: float) -> void:
	if player and player._velocity.raw_direction.length() > 0:
		player.state_chart.send_event(&"onMoving")


func _on_idle_state_entered() -> void:
	player.stat_energy.growth_rate = player.stat_energy.max_value * player.player_stats.idle_energy_growth_factor
	player.stat_momentum.growth_rate = player.stat_momentum.max_value * player.player_stats.idle_momentum_growth_factor
	player.stat_momentum.allow_growth = true
	player.fp_rig.transition_movement(PlayerFirstPersonRig.MovementStates.Idle)


func _on_idle_state_exited() -> void:
	player.stat_momentum.growth_rate = player.stat_momentum.max_value * player.player_stats.idle_energy_growth_factor
	player.stat_momentum.allow_growth = false
