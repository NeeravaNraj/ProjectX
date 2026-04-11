extends MeleeEnemyState

@onready var search_timer = $SearchTimer
@onready var anim_timer = $SearchAnimTimer

func _on_searching_state_entered() -> void:
	if not search_timer.is_stopped(): search_timer.stop()
	anim_timer.stop()
	search_timer.start()

func _on_search_timer_timeout() -> void:
	await melee_enemy.enemy_skin.anim_tree.animation_finished
	melee_enemy.state_chart.send_event(&"onReturning")

func _on_searching_state_exited() -> void:
	search_timer.stop()

func _on_searching_state_physics_processing(_delta: float) -> void:
	if not melee_enemy: return

	if melee_enemy.can_see_player():
		melee_enemy.state_chart.send_event(&"onAggravated")
	
	melee_enemy.speed = melee_enemy.stats.search_speed
	if melee_enemy.navigation_agent.is_navigation_finished() and melee_enemy.velocity.length() == 0:
		if anim_timer.is_stopped():
			melee_enemy.enemy_skin.searching()
			anim_timer.start(randf_range(4, 7))
	else:
		melee_enemy.move_towards_target()
