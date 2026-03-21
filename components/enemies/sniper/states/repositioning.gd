extends SniperEnemyState


@onready var dummy_timer: Timer = $DummyTimer


func _on_repositioning_state_entered() -> void:
	print("Begin repositioning")
	dummy_timer.start()


func _on_repositioning_state_physics_processing(delta: float) -> void:
	pass

func _on_dummy_timer_timeout() -> void:
	sniper_enemy.state_chart.send_event("onAiming")

func _on_repositioning_state_exited() -> void:
	print("Done repositioning")
