extends PlayerState


func _on_falling_state_entered() -> void:
	player._fp_rig.transition_movement(PlayerFirstPersonRig.MovementStates.Falling)
