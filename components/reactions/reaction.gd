class_name Reaction extends Element

@export var reaction_dmg_multiplier := 1.5

enum ReactionKind {
	Vaporize, # Fire - water
	FireStorm, # Fire - Wind
	Overload, # Fire - Thunder
	Electrocute, # Water - Thunder
	Maelstrom, # Water - Wind
	Thunderstorm, # Wind - Thunder
	Erode, # Earth - Water
	Emberquake, # Earth - Fire
	Sandstorm, # Earth - Wind
	Stormquake, # Earth - Thunder
	
	Oblivion, # Ether - anything
}

var REACTION_MAP := {
	# Fire combinations
	_make_key(ElementKind.Fire, ElementKind.Water): ReactionKind.Vaporize,
	_make_key(ElementKind.Fire, ElementKind.Wind): ReactionKind.FireStorm,
	_make_key(ElementKind.Fire, ElementKind.Thunder): ReactionKind.Overload,
	_make_key(ElementKind.Fire, ElementKind.Earth): ReactionKind.Emberquake,

	# Water combinations
	_make_key(ElementKind.Water, ElementKind.Thunder): ReactionKind.Electrocute,
	_make_key(ElementKind.Water, ElementKind.Wind): ReactionKind.Maelstrom,
	_make_key(ElementKind.Water, ElementKind.Earth): ReactionKind.Erode,

	# Wind combinations
	_make_key(ElementKind.Wind, ElementKind.Thunder): ReactionKind.Thunderstorm,
	_make_key(ElementKind.Wind, ElementKind.Earth): ReactionKind.Sandstorm,

	# Thunder combinations
	_make_key(ElementKind.Thunder, ElementKind.Earth): ReactionKind.Stormquake,
	
	# Ether reactions
	_make_key(ElementKind.Ether, ElementKind.Water): ReactionKind.Oblivion,
	_make_key(ElementKind.Ether, ElementKind.Wind): ReactionKind.Oblivion,
	_make_key(ElementKind.Ether, ElementKind.Thunder): ReactionKind.Oblivion,
	_make_key(ElementKind.Ether, ElementKind.Earth): ReactionKind.Oblivion,
	_make_key(ElementKind.Ether, ElementKind.Fire): ReactionKind.Oblivion,
}

var reaction_keys = ReactionKind.keys()

func get_reaction(a: ElementKind, b: ElementKind) -> ReactionKind:
	var key = _make_key(a, b)
	return REACTION_MAP.get(key, null)

func get_reaction_name(r: ReactionKind):
	return reaction_keys[r]
