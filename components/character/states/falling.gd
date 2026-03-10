extends PlayerState


func _on_falling_state_entered() -> void:
	player.fp_rig.transition_movement(PlayerFirstPersonRig.MovementStates.Falling)
