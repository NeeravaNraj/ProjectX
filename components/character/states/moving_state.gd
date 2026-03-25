extends PlayerState



func _on_moving_state_physics_processing(_delta: float) -> void:
	if not player: return
	
	if player._velocity.raw_direction.length() == 0 and player.velocity.length() < 0.5:
		player.state_chart.send_event(&"onIdle")
	else:
		player.state_chart.send_event(&"onSprinting")


func _on_moving_state_entered() -> void:
	player.stat_energy.growth_rate = player.stat_energy.max_value * player.player_stats.movement_energy_growth_factor
