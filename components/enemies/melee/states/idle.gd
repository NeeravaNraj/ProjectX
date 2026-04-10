extends MeleeEnemyState


func _on_idle_state_physics_processing(delta: float) -> void:
	if not (melee_enemy or melee_enemy.enabled): return

	if melee_enemy.get_player_distance() <= melee_enemy.get_vistion_radius():
		melee_enemy.state_chart.send_event(&"onAggravated")
	
	melee_enemy.enemy_skin.locomotion(MeleeEnemySkin.MovementStates.Idle)
	melee_enemy.speed = melee_enemy.stats.move_speed
	melee_enemy.move_towards_target()
