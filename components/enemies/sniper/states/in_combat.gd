extends SniperEnemyState


func _on_in_combat_state_physics_processing(delta: float) -> void:
	if not sniper_enemy or not sniper_enemy.player: return

	if sniper_enemy.get_player_distance() > sniper_enemy.get_vistion_radius():
		sniper_enemy.last_player_position = sniper_enemy.player.global_position
		sniper_enemy.state_chart.send_event(&"onSearching")
