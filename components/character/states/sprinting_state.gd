extends PlayerState


func _on_sprinting_state_physics_processing(_delta: float) -> void:
	if not player: return
	player.sprint()


func _on_sprinting_state_entered() -> void:
	player.fp_rig.transition_movement(PlayerFirstPersonRig.MovementStates.Running)
