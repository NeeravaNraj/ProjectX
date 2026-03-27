extends MeleeEnemyState


func _on_idle_state_physics_processing(delta: float) -> void:
	if not melee_enemy: return

	for body in melee_enemy.player_detection_area.get_overlapping_bodies():
		if body is Player:
			melee_enemy.player = body
			melee_enemy.state_chart.send_event(&"onAggravated")

	melee_enemy.speed = melee_enemy.enemy_stats.move_speed
	melee_enemy.move_towards_target()
