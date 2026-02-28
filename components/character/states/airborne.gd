extends PlayerState


func _on_airborne_state_physics_processing(delta: float) -> void:
	if not player: return
	
	if player.is_on_floor():
		player._state_chart.send_event("onGround")
