extends EnemyState


func _on_attacking_state_physics_processing(delta: float) -> void:
	if not enemy: return
	
	if enemy.get_player_distance() > enemy.enemy_stats.attack_range:
		enemy.state_chart.send_event(&"onAggravated")
	print("ATTACK")
