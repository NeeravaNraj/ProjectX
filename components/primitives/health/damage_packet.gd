class_name DamagePacket extends RefCounted

var attack_direction: Vector3 = Vector3.ZERO

var flat_damage: float
var element: Element.ElementKind

var base_knockback: float = 1.5

var base_style_multiplier: float = 1.0
var base_reaction_multiplier: float = 1.5

# From items and other possibly sources
var knockback_modifier: float = 0.0
var flat_damage_modifier: float = 0.0

var style_multiplier: float = 0.0
var reaction_multiplier: float = 0.0

var reaction_conditional_multipliers: Dictionary[Element.ElementKind, float] = {}

func _init(
	p_flat_damage: float,
	p_element: Element.ElementKind,
	p_style_multiplier: float = 0.0,
	p_reaction_multiplier: float = 0.0,
	p_knockback_modifier: float = 0.0,
	p_flat_damage_modifier: float = 0.0,
) -> void:
	flat_damage = p_flat_damage
	element = p_element
	style_multiplier = p_style_multiplier
	reaction_multiplier = p_reaction_multiplier
	
	knockback_modifier = p_knockback_modifier
	flat_damage_modifier = p_flat_damage_modifier

func consolidate_conditional_multipliers(elements: Array[Element.ElementKind]):
	for el in elements:
		var multiplier = reaction_conditional_multipliers.get(el, null)
		
		if multiplier:
			reaction_multiplier += multiplier
