extends PlayerState


func _on_grounded_state_physics_processing(delta: float) -> void:
	if not player: return
	
	if not player.is_on_floor():
		player._state_chart.send_event(&"onAirborne")


func _on_grounded_state_unhandled_input(event: InputEvent) -> void:
	if not player: return
	
	if Input.is_action_just_pressed(&"jump"):
		player.jump()
		player._state_chart.send_event(&"onJumping")
