extends PlayerState

@onready var jump_timer: Timer = $JumpTimer 


func _on_jumping_state_entered() -> void:
	if jump_timer.is_stopped(): jump_timer.stop()
	jump_timer.start()
	player._velocity.gravity_modifier = 0.0
	player.stat_energy.growth_rate = player.stat_energy.max_value * player.player_stats.jump_energy_growth_factor

func _on_jump_timer_timeout() -> void:
	if not player: return 
	player.state_chart.send_event(&"onFalling")

func _on_jumping_state_exited() -> void:
	jump_timer.stop()
