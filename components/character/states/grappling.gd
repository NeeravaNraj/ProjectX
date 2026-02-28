extends PlayerState

@onready var grapple_timer: Timer = $GrappleTimer 


func _on_grappling_state_entered() -> void:
	if grapple_timer.is_stopped(): grapple_timer.stop()
	grapple_timer.start()

func _on_grapple_timer_timeout() -> void:
	if not player: return
	player._state_chart.send_event(&"onFalling")

func _on_grappling_state_exited() -> void:
	grapple_timer.stop()
