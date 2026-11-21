extends PlayerState


func _on_idle_state_physics_processing(_delta: float) -> void:
	if player and player._velocity.raw_direction.length() > 0:
		player.state_chart.send_event(&"onMoving")


func _on_idle_state_entered() -> void:
	if player == null or stats == null: return
	var idle_energy_growth_factor = stats.get_computed_stat(player.stat_ident.IdleEnergyGrowthFactor)
	var idle_momentum_growth_factor = stats.get_computed_stat(player.stat_ident.IdleMomentumGrowthFactor)

	player.stat_energy.growth_rate = player.stat_energy.max_value * idle_energy_growth_factor
	player.stat_momentum.growth_rate = player.stat_momentum.max_value * idle_momentum_growth_factor
	player.stat_momentum.allow_growth = true
	player.fp_rig.transition_movement(PlayerFirstPersonRig.MovementStates.Idle)


func _on_idle_state_exited() -> void:
	if player == null or stats == null: return
	var idle_energy_growth_factor = stats.get_computed_stat(player.stat_ident.IdleEnergyGrowthFactor)

	player.stat_momentum.growth_rate = player.stat_momentum.max_value * idle_energy_growth_factor
	player.stat_momentum.allow_growth = false
