extends PlayerState


func _on_dashing_state_entered() -> void:
	player.stat_energy.growth_rate = player.stat_energy.max_value * player.player_stats.movement_energy_growth_factor
