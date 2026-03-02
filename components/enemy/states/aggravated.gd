extends EnemyState


func _on_aggravated_state_entered() -> void:
	if not enemy: return
	enemy.alert.emit(enemy.global_position, enemy.player.global_position)
	enemy.navigation_agent.set_target_position(enemy.player.global_position)

func _on_aggravated_state_physics_processing(delta: float) -> void:
	if not enemy: return
	
	if enemy.get_player_distance() < enemy.enemy_stats.attack_range:
		enemy.state_chart.send_event(&"onAttacking")
	
	enemy.move_towards_target(enemy.enemy_stats.move_speed)
