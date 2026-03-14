extends MeleeEnemyState


func _on_attacking_state_physics_processing(delta: float) -> void:
	if not melee_enemy: return

	if melee_enemy.get_player_distance() > melee_enemy.enemy_stats.attack_range:
		melee_enemy.state_chart.send_event(&"onAggravated")
	print("ATTACK")
