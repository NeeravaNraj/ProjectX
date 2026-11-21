class_name StatsComponent extends Node

enum StatIdent {
	MaxHealth,
	MaxEnergy,
	MaxMomentum,
	
	MoveSpeed,
	DashMoveSpeed,
	
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

	AirJumpMax,
	JumpVelocity,
	WallRunJumpVelocity,

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

const DEFAULT_VALUES: Dictionary[StatIdent, float] = {
	StatIdent.MaxHealth: 100.0,
	StatIdent.MaxEnergy: 2.0,
	StatIdent.MaxMomentum: 5.0,
	StatIdent.MoveSpeed: 10.0,
	StatIdent.DashMoveSpeed: 35.0,

	StatIdent.AirJumpMax: 0,
	StatIdent.JumpVelocity: 12.0,
	StatIdent.WallRunJumpVelocity: 15,

	StatIdent.IdleEnergyGrowthFactor: -0.1,
	StatIdent.MovementEnergyGrowthFactor: 0.025,
	StatIdent.DashEnergyGrowthFactor: 0.05,
	StatIdent.JumpEnergyGrowthFactor: 0.05,
	StatIdent.WallRunEnergyGrowthFactor: 0.08,
	StatIdent.GrappleEnergyGrowthFactor: 0.1,
	StatIdent.BoostEnergyGrowthFactor: 0.15,

	StatIdent.IdleMomentumGrowthFactor: -0.1,
	StatIdent.BoostMomentumGrowthFactor: -0.1,
	StatIdent.AttackMomentumGrowthFactor: 0.2,

	StatIdent.GrappleTime: 0.32,
	StatIdent.MaxGrappleSpeed: 38,
	StatIdent.MinGrappleSpeed: 30,

	StatIdent.AttackDamage: 10.0,
	StatIdent.AttackSpeed: 0,
	StatIdent.CritChance: 0,
	StatIdent.CritDamage: 0,

	StatIdent.AttackRange: 1.5,
	StatIdent.VisionDistance: 50,
	StatIdent.AvoidanceSpeed: 8.0,
	StatIdent.AimPredictionTime: 0.0,
	StatIdent.MinDistanceFromTarget: 0.0,
	StatIdent.PreferredAllyDistance: 2.0,
}

var stats: Dictionary[StatIdent, Stat] = {}
var _modifiers_by_source: Dictionary = {}

func _ready() -> void:
	_build_defaults()
	
func get_base_value(stat_id: StatIdent):
	return stats[stat_id].value

func set_base_stat_value(stat_id: StatIdent, value: float):
	stats[stat_id].value = value
	stat_changed.emit(stat_id)

func get_computed_stat(stat_id: StatIdent):
	if not stats.has(stat_id): return
	var stat = stats[stat_id]
	var value = stat.value
	var overrides = stat.modifiers[StatModifier.ModificationKind.Override] as Array[StatModifier]
	
	if not overrides.is_empty():
		return overrides.front().value
	
	var add = stat.modifiers[StatModifier.ModificationKind.Add] as Array[StatModifier]
	var add_percent = stat.modifiers[StatModifier.ModificationKind.AdditivePercentage] as Array[StatModifier]
	var mult_percent = stat.modifiers[StatModifier.ModificationKind.MultiplicativePercentage] as Array[StatModifier]
	var min_clamp = stat.modifiers[StatModifier.ModificationKind.MinClamp] as Array[StatModifier]
	var max_clamp = stat.modifiers[StatModifier.ModificationKind.MaxClamp] as Array[StatModifier]
	
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
		stat.modifiers[entry.modifier.modification_kind].erase(entry.modifier)
	
	for id in stat_set.keys():
		stat_changed.emit(id)
	
	_modifiers_by_source.erase(src)


func _build_defaults():
	for id in StatIdent.values():
		var value = DEFAULT_VALUES[id]
		stats[id] = Stat.new(value)
