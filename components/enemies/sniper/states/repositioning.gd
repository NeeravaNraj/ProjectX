extends SniperEnemyState


func _on_repositioning_state_entered() -> void:
	print("Begin repositioning")


func _on_repositioning_state_physics_processing(delta: float) -> void:
	pass


func _on_repositioning_state_exited() -> void:
	print("Done repositioning")
