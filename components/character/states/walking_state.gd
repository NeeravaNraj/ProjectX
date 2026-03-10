extends PlayerState


func _on_walking_state_physics_processing(_delta: float) -> void:
	if not player: return
	player.walk()
