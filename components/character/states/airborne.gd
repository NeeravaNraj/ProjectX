extends PlayerState


func _on_airborne_state_physics_processing(_delta: float) -> void:
	if not player: return
	
	if player.is_on_floor():
		player.state_chart.send_event(&"onGround")

	if player.is_on_wall():
		_try_switch_to_wall_run()
	
func _try_switch_to_wall_run():
	var wall_normal = player.get_wall_normal()
	var forward = player.get_forward()
	var perpendicular = forward.dot(wall_normal)
	
	if perpendicular >= -0.7 and perpendicular <= 0.6:
		player.state_chart.send_event(&"onWallrun")
