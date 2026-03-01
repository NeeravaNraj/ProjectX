class_name ReactionHandler extends Reaction

class ReactionData:
	var reaction: Reaction.ReactionKind
	var elements: Array[Element.ElementKind]

var _current_state: Variant = null

func apply_element_state(element: Element.ElementKind):
	if not _current_state:
		_current_state = element
	
	return _resolve_reaction(element)

func _resolve_reaction(element: Element.ElementKind) -> ReactionData:
	var reaction = get_reaction(_current_state, element)
	assert(reaction, "Unknown reaction between '%s' and '%s'" % [get_element_name(_current_state), get_element_name(element)])
	
	var reaction_data = ReactionData.new()
	reaction_data.reaction = reaction
	reaction_data.elements = [_current_state, element]
	_current_state = null
	return reaction_data
