extends MeleeEnemyState

@onready var search_timer = $SearchTimer


func _on_searching_state_entered() -> void:
	if not search_timer.is_stopped(): search_timer.stop()
	search_timer.start()

func _on_search_timer_timeout() -> void:
	melee_enemy.player = null
	melee_enemy.last_player_position = null
	melee_enemy.navigation_agent.set_target_position(melee_enemy.starting_position)
	melee_enemy.state_chart.send_event(&"onIdle")

func _on_searching_state_exited() -> void:
	search_timer.stop()


func _on_searching_state_physics_processing(_delta: float) -> void:
	if not melee_enemy: return

	if melee_enemy.get_player_distance() < melee_enemy.get_vistion_radius():
		melee_enemy.state_chart.send_event(&"onAggravated")

	melee_enemy.speed = melee_enemy.enemy_stats.search_speed
	melee_enemy.move_towards_target()
