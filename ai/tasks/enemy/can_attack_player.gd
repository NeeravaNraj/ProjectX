@tool
extends BTCondition

@export var invert: bool = false

func _tick(_delta: float) -> Status:
	var can_attack = agent.can_attack_player()
	
	if invert:
		can_attack = !can_attack
	
	if can_attack: return SUCCESS
	
	return FAILURE

func _generate_name() -> String:
	var cond = "cannot" if invert else "can"
	return "Check if: 'player' %s be attacked" % [cond]
