extends PlayerState

const PARRY_SPEED := -2.0

func _on_parrying_state_entered() -> void:
	player.player_stats.move_speed_modifier += PARRY_SPEED
	player.fp_rig.parry(true)


func _on_parrying_state_exited() -> void:
	player.player_stats.move_speed_modifier -= PARRY_SPEED
	player.fp_rig.parry(false)
