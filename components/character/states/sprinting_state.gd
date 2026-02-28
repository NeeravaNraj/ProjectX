extends PlayerState


func _on_sprinting_state_physics_processing(delta: float) -> void:
	if not player: return
	
	player.sprint()
