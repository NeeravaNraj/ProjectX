extends EnemyState

@onready var damage_timer = $DamageTimer

func _on_damaged_state_entered() -> void:
	enemy._velocity.add_impulse(enemy.hit_direction, 15)
	damage_timer.start()


func _on_damage_timer_timeout() -> void:
	enemy.state_chart.send_event(&"onAttacking")
