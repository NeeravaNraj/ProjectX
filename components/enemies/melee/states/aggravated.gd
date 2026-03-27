extends MeleeEnemyState


func _on_aggravated_state_entered() -> void:
	if not melee_enemy or not melee_enemy.player: return
	melee_enemy.alert.emit(melee_enemy.global_position, melee_enemy.player.global_position)
	melee_enemy.navigation_agent.set_target_position(melee_enemy.player.global_position)


func _on_aggravated_state_physics_processing(delta: float) -> void:
	if not melee_enemy or not melee_enemy.player: return

	if melee_enemy.get_player_distance() < melee_enemy.enemy_stats.attack_range:
		melee_enemy.state_chart.send_event(&"onAttacking")
	elif melee_enemy.navigation_agent.is_navigation_finished():
		melee_enemy.navigation_agent.set_target_position(melee_enemy.player.global_position)

	melee_enemy.speed = melee_enemy.enemy_stats.move_speed
	melee_enemy.move_towards_target()
