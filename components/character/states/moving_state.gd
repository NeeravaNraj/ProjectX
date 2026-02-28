extends PlayerState


func _on_moving_state_physics_processing(delta: float) -> void:
	if not player: return
	
	if player._velocity.raw_direction.length() == 0 and player.velocity.length() < 0.5:
		player._state_chart.send_event(&"onIdle")
	

func _on_moving_state_unhandled_input(event: InputEvent) -> void:
	if not player: return
	
	if Input.is_action_pressed(&"sprint"):
		player._state_chart.send_event(&"onSprinting")
	else:
		player._state_chart.send_event(&"onWalking")
