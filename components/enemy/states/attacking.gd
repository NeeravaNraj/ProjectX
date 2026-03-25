extends EnemyState

@onready var attack_timer = $AttackTimer

func _on_attacking_state_physics_processing(_delta: float) -> void:
	if not enemy: return
	
	if enemy.get_player_distance() > enemy.enemy_stats.attack_range:
		enemy.state_chart.send_event(&"onAggravated")
	
	if attack_timer.is_stopped():
		# print("ATTACK")
		attack_timer.start()
