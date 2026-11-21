extends PlayerState

const PARRY_SPEED := -4.0

func _on_parrying_state_entered() -> void:
	var modifier = StatModifier.new(
		self, 
		player.stat_ident.MoveSpeed,
		StatModifier.ModificationKind.Add,
		PARRY_SPEED
	)
	player.stats.add_modifiers([modifier])
	player.fp_rig.parry(true)


func _on_parrying_state_exited() -> void:
	player.stats.remove_modifiers_by_source(self)
	player.fp_rig.parry(false)
