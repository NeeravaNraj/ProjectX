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
