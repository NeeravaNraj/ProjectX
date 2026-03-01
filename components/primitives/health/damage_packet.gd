class_name DamagePacket extends RefCounted

var flat_damage: float
var element: Element.ElementKind

var base_style_multiplier: float = 1.0
var base_reaction_multiplier: float = 1.5

# From items and other possibly sources
var style_multiplier: float = 0.0
var reaction_multiplier: float = 0.0

var reaction_conditional_multipliers: Dictionary[Element.ElementKind, float] = {}

func _init(
	p_flat_damage: float,
	p_element: Element.ElementKind,
	p_style_multiplier: float = 0.0,
	p_reaction_multiplier: float = 0.0,
) -> void:
	flat_damage = p_flat_damage
	element = p_element
	style_multiplier = p_style_multiplier
	reaction_multiplier = p_reaction_multiplier

func consolidate_conditional_multipliers(elements: Array[Element.ElementKind]):
	for element in elements:
		var multiplier = reaction_conditional_multipliers.get(element, null)
		
		if multiplier:
			reaction_multiplier += multiplier
