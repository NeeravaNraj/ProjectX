extends EnemyState


func _on_idle_state_physics_processing(delta: float) -> void:
	if not enemy: return

	for body in enemy.detection_area.get_overlapping_bodies():
		if body is Player:
			enemy.player = body
			enemy.state_chart.send_event(&"onAggravated")
	
	enemy.speed = enemy.enemy_stats.move_speed
