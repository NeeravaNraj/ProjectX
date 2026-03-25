extends SniperEnemyState


func _on_aggravated_state_physics_processing(_delta: float) -> void:
	if not sniper_enemy or not sniper_enemy.player: return

	if sniper_enemy.get_player_distance() < sniper_enemy.stats.scared_distance and sniper_enemy.navigation_agent.is_navigation_finished():
		sniper_enemy.navigation_agent.set_target_position(
			sniper_enemy.global_position + (sniper_enemy.global_position - sniper_enemy.player.global_position).normalized() * sniper_enemy.stats.scared_move_distance
		)

	sniper_enemy.speed = sniper_enemy.stats.move_speed
	sniper_enemy.move_towards_target()
