extends MeleeEnemyState


func _on_in_combat_state_physics_processing(delta: float) -> void:
	if not melee_enemy or not melee_enemy.player: return

	if melee_enemy.get_player_distance() > melee_enemy.get_vistion_radius():
		melee_enemy.last_player_position = melee_enemy.player.global_position
		melee_enemy.state_chart.send_event(&"onSearching")
