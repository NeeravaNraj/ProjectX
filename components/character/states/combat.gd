extends PlayerState

var held = false
func _on_combat_state_unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed(&"right_click"):
		held = true
		player.state_chart.send_event(&"onParry")
	
	if held and Input.is_action_just_released(&"right_click"):
		held = false
		player.state_chart.send_event(&"onNormal")
