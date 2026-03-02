extends EnemyState


func _on_attacking_state_physics_processing(delta: float) -> void:
	if not enemy: return
	print("ATTACK")
