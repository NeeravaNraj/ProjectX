extends MeleeEnemyState

@onready var attack_timer: Timer = $AttackTimer
var can_attack: bool = true

func _on_attacking_state_physics_processing(delta: float) -> void:
	if not melee_enemy: return

	if can_attack && melee_enemy.get_player_distance() > melee_enemy.stats.attack_range:
		melee_enemy.state_chart.send_event(&"onAggravated")
	elif can_attack:
		var packet = DamagePacket.new(melee_enemy.stats.attack_damage)
		melee_enemy.enemy_skin.attack(packet)
		can_attack = false
	
	melee_enemy.enemy_skin.locomotion(MeleeEnemySkin.MovementStates.Idle)

func _on_melee_enemy_skin_attack_finished() -> void:
	can_attack = true

func _on_attacking_state_entered() -> void:
	can_attack = true
