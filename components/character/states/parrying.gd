extends PlayerState


func _on_parrying_state_entered() -> void:
	player.fp_rig.parry(true)


func _on_parrying_state_exited() -> void:
	player.fp_rig.parry(false)
