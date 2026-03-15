extends SniperEnemyState


func _on_idle_state_physics_processing(delta: float) -> void:
	if not sniper_enemy: return

	for body in sniper_enemy.player_detection_area.get_overlapping_bodies():
		if body is Player:
			sniper_enemy.player = body
			sniper_enemy.state_chart.send_event(&"onAggravated")

	sniper_enemy.speed = sniper_enemy.enemy_stats.move_speed
	sniper_enemy.move_towards_target()
