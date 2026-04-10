extends MeleeEnemyState

var target_dist_original = 0

func _on_returning_state_entered() -> void:
	if not melee_enemy: return
	target_dist_original = melee_enemy.navigation_agent.target_desired_distance
	melee_enemy.navigation_agent.target_desired_distance = 0
	melee_enemy.navigation_agent.set_target_position(melee_enemy.starting_position)


func _on_returning_state_physics_processing(_delta: float) -> void:
	if not melee_enemy: return
	
	if melee_enemy.get_player_distance() < melee_enemy.get_vistion_radius():
		melee_enemy.state_chart.send_event(&"onAggravated")
	
	if melee_enemy.navigation_agent.is_navigation_finished():
		melee_enemy.state_chart.send_event(&"onIdle")
	
	melee_enemy.speed = melee_enemy.stats.move_speed
	melee_enemy.move_towards_target()
	
func _on_returning_state_exited() -> void:
	melee_enemy.navigation_agent.target_desired_distance = target_dist_original
	melee_enemy.lookat_player()
