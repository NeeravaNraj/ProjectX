extends SniperEnemyState


func _on_shooting_state_entered() -> void:
	print("Shooting...")
	sniper_enemy.state_chart.send_event("onRepositioning")
