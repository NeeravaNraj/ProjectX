extends PlayerState


func _on_idle_state_physics_processing(delta: float) -> void:
	if player and player._velocity.raw_direction.length() > 0:
		player._state_chart.send_event("onMoving")
