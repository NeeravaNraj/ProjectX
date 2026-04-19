@tool
extends BTCondition

@export var invert: bool = false


func _tick(_delta: float) -> Status:
	agent = agent as BaseEnemy
	var player_visible = agent.can_see_player()
	
	if invert:
		player_visible = !player_visible
	
	if player_visible: return SUCCESS
	
	return FAILURE

func _generate_name() -> String:
	var cond = "is not" if invert else "is"
	return "Check if: 'player' %s 'visible'" % [cond]
