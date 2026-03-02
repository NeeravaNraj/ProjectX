extends EnemyState


func _on_in_combat_state_physics_processing(delta: float) -> void:
	if not enemy: return
	
	var player_position = enemy.player.global_position
	var distance = enemy.global_position.distance_to(player_position)
	
	if distance > enemy.get_vistion_radius():
		enemy.last_player_position = enemy.player.global_position
		enemy.state_chart.send_event(&"onSearching")
