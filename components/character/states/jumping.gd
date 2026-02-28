extends PlayerState

@onready var jump_timer: Timer = $JumpTimer 


func _on_jumping_state_entered() -> void:
	if jump_timer.is_stopped(): jump_timer.stop()
	jump_timer.start()

func _on_jump_timer_timeout() -> void:
	if not player: return
	player._state_chart.send_event(&"onFalling")

func _on_jumping_state_exited() -> void:
	jump_timer.stop()
