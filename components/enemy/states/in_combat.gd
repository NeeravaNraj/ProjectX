extends EnemyState


func _on_in_combat_state_physics_processing(_delta: float) -> void:
	if not enemy or not enemy.player: return
	
	if enemy.get_player_distance() > enemy.get_vistion_radius():
		enemy.last_player_position = enemy.player.global_position
		enemy.state_chart.send_event(&"onSearching")
