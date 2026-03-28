extends MeleeEnemyState

@onready var attack_timer: Timer = $AttackTimer

func _on_attacking_state_physics_processing(delta: float) -> void:
	if not melee_enemy: return

	if melee_enemy.get_player_distance() > melee_enemy.stats.attack_range:
		melee_enemy.state_chart.send_event(&"onAggravated")
	
	if attack_timer.is_stopped():
		var packet = DamagePacket.new(melee_enemy.stats.attack_damage)
		melee_enemy.hitbox.attack(packet)
		attack_timer.start()
