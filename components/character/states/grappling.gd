extends PlayerState

@onready var grapple_timer: Timer = $GrappleTimer 


func _on_grappling_state_entered() -> void:
	if grapple_timer.is_stopped(): grapple_timer.stop()
	grapple_timer.start()
	player.fp_rig.transition_movement(PlayerFirstPersonRig.MovementStates.Falling)
	player._velocity.gravity_modifier = 0.0
	player.stat_energy.growth_rate = player.stat_energy.max_value * player.player_stats.grapple_energy_growth_factor

func _on_grapple_timer_timeout() -> void:
	if not player: return
	player.state_chart.send_event(&"onFalling")

func _on_grappling_state_exited() -> void:
	grapple_timer.stop()

func _on_player_grappled() -> void:
	grapple_timer.stop()
	grapple_timer.start()
