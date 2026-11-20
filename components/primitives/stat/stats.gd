class_name StatsComponent extends Node

enum StatIdent {
	MaxHealth,
	
	MoveSpeed,
	DashMoveSpeed,
	
	MaxEnergy,
	MaxMomentum,
	IdleEnergyGrowthFactor,
	MovementEnergyGrowthFactor,
	DashEnergyGrowthFactor,
	JumpEnergyGrowthFactor,
	WallRunEnergyGrowthFactor,
	GrappleEnergyGrowthFactor,
	BoostEnergyGrowthFactor,

	IdleMomentumGrowthFactor,
	BoostMomentumGrowthFactor,
	AttackMomentumGrowthFactor,

	JumpVelocity,
	WallRunJumpVelocity,
	AirJumpMax,

	GrappleTime,
	MaxGrappleSpeed,
	MinGrappleSpeed,

	AttackDamage,
	AttackRange,
	AttackSpeed,
	CritChance,
	CritDamage,
	
	# Enemy specific stats
	VisionDistance,
	AvoidanceSpeed,
	AimPredictionTime,
	MinDistanceFromTarget,
	PreferredAllyDistance,
}

class Stat:
	var value: float
	var modifiers: Dictionary[StatModifier.ModificationKind, Array]
	
	func _init(p_val: float = 0) -> void:
		value = p_val
		modifiers = {}
		for i in StatModifier.ModificationKind.values():
			modifiers[i] = []

signal stat_changed(stat_id: StatIdent)

var stats: Dictionary[StatIdent, Stat] = {}
var _modifiers_by_source: Dictionary = {}

func set_base_stat_value(stat_id: StatIdent, value: float):
	stats[stat_id].value = value
	stat_changed.emit(stat_id)

func get_computed_stat(stat_id: StatIdent):
	if not stats.has(stat_id): return
	var stat = stats[stat_id]
	var value = stat.value
	var overrides: Array[StatModifier] = stat.modifiers[StatModifier.ModificationKind.Override]
	
	if not overrides.is_empty():
		return overrides.front().value
	
	var add: Array[StatModifier] = stat.modifiers[StatModifier.ModificationKind.Add]
	var add_percent: Array[StatModifier] = stat.modifiers[StatModifier.ModificationKind.AdditivePercentage]
	var mult_percent: Array[StatModifier] = stat.modifiers[StatModifier.ModificationKind.MultiplicativePercentage]
	var min_clamp: Array[StatModifier] = stat.modifiers[StatModifier.ModificationKind.MinClamp]
	var max_clamp: Array[StatModifier] = stat.modifiers[StatModifier.ModificationKind.MaxClamp]
	
	var flat_value = add.reduce(func(acc, e): return acc + e.value * e.stacks, 0)
	var add_percent_value = add_percent.reduce(func (acc, e): return acc + e.value * e.stacks, 1)
	var mult_percent_value = mult_percent.reduce(func (acc, e): return acc * pow(1 + e.value, e.stacks), 1)
	var min_clamp_value = -INF if min_clamp.is_empty() else min_clamp.front().value
	var max_clamp_value = INF if max_clamp.is_empty() else max_clamp.front().value
	
	return clampf((value + flat_value) * add_percent_value * mult_percent_value, min_clamp_value, max_clamp_value)

func add_modifiers(modifiers: Array[StatModifier]):
	var stat_set = {}
	for mod in modifiers:
		stat_set[mod.target] = 1
		stats[mod.target].modifiers[mod.modification_kind].append(mod)
		if not _modifiers_by_source.has(mod.source):
			_modifiers_by_source[mod.source] = []
		
		_modifiers_by_source[mod.source].append({
			"stat_id": mod.target,
			"modifier": mod,
		})
	
	for id in stat_set.keys():
		stat_changed.emit(id)

func remove_modifiers_by_source(src: Object):
	if not _modifiers_by_source.has(src): return
	
	var stat_set = {}
	for entry in _modifiers_by_source[src]:
		var stat = stats[entry.stat_id]
		stat_set[entry.stat_id] = 1
		stat.modifiers[entry.modifier.kind].erase(entry.modifier)
	
	for id in stat_set.keys():
		stat_changed.emit(id)
	
	_modifiers_by_source.erase(src)
