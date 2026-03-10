extends PlayerState


func _on_moving_state_physics_processing(_delta: float) -> void:
	if not player: return
	
	if player._velocity.raw_direction.length() == 0 and player.velocity.length() < 0.5:
		player.state_chart.send_event(&"onIdle")
	else:
		player.state_chart.send_event(&"onSprinting")
