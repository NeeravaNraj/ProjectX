extends PlayerState


func _on_idle_state_physics_processing(_delta: float) -> void:
	if player and player._velocity.raw_direction.length() > 0:
		player.state_chart.send_event(&"onMoving")


func _on_idle_state_entered() -> void:
	player.fp_rig.transition_movement(PlayerFirstPersonRig.MovementStates.Idle)
