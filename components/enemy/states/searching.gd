extends EnemyState

@onready var search_timer = $SearchTimer


func _on_searching_state_entered() -> void:
	if not search_timer.is_stopped(): search_timer.stop()
	search_timer.start()
	
func _on_search_timer_timeout() -> void:
	print("TIMEOUT")
	enemy.state_chart.send_event(&"onIdle")

func _on_searching_state_exited() -> void:
	search_timer.stop()
	enemy.player = null
	enemy.last_player_position = null
	enemy.navigation_agent.set_target_position(enemy.starting_position)


func _on_searching_state_physics_processing(_delta: float) -> void:
	if not enemy: return
	
	if enemy.get_player_distance() < enemy.get_vistion_radius():
		enemy.state_chart.send_event(&"onAggravated")
	
	enemy.speed = enemy.enemy_stats.search_speed
	enemy.move_towards_target()
