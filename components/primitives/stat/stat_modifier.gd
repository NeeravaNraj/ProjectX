class_name StatModifier extends RefCounted

enum ModificationKind {
	Add,
	AdditivePercentage,
	MultiplicativePercentage,
	MinClamp,
	MaxClamp,
	Override
}

var source: Object
var target: StatsComponent.StatIdent
var modification_kind: ModificationKind

var value: float
var stacks: float = 1

func _init(
	p_src: Object,
	p_target: StatsComponent.StatIdent,
	p_kind: ModificationKind,
	p_value: float
):
	source = p_src
	target = p_target
	modification_kind = p_kind
	value = p_value

static func flat(
	p_src: Object,
	p_target: StatsComponent.StatIdent,
	p_value: float
) -> StatModifier:

	return StatModifier.new(p_src, p_target, ModificationKind.Add, p_value)

static func flat_percent(
	p_src: Object,
	p_target: StatsComponent.StatIdent,
	p_value: float
) -> StatModifier:
	
	return StatModifier.new(p_src, p_target, ModificationKind.AdditivePercentage, p_value)

static func mult_percent(
	p_src: Object,
	p_target: StatsComponent.StatIdent,
	p_value: float
) -> StatModifier:
	
	return StatModifier.new(p_src, p_target, ModificationKind.MultiplicativePercentage, p_value)

static func min_clamp(
	p_src: Object,
	p_target: StatsComponent.StatIdent,
	p_value: float
) -> StatModifier:
	
	return StatModifier.new(p_src, p_target, ModificationKind.MinClamp, p_value)

static func max_clamp(
	p_src: Object,
	p_target: StatsComponent.StatIdent,
	p_value: float
) -> StatModifier:
	
	return StatModifier.new(p_src, p_target, ModificationKind.MaxClamp, p_value)

static func override(
	p_src: Object,
	p_target: StatsComponent.StatIdent,
	p_value: float
) -> StatModifier:
	
	return StatModifier.new(p_src, p_target, ModificationKind.Override, p_value)
