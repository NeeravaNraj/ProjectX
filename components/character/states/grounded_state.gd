extends PlayerState

func _on_grounded_child_state_entered() -> void:
	player.fp_rig.abort_jump()

func _on_grounded_state_physics_processing(_delta: float) -> void:
	if not player: return
	
	if not player.is_on_floor():
		player.state_chart.send_event(&"onAirborne")
	
	


func _on_grounded_state_unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(&"jump"):
		player.jump()
		player.state_chart.send_event(&"onJumping")
	
	if event.is_action_pressed(&"dash"):
		player.dash()
		player.state_chart.send_event(&"onDashing")
