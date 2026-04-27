@tool
extends BTAction

@export var store_var: StringName = &"target_position"

var position = null

func _enter() -> void:
	position = agent.get_position_near_ally()
	
	var player = agent.player.global_position
	if position and position.distance_to(player) > agent.stats.attack_range:
		position = null

func _tick(_delta: float) -> Status:
	if not position: return FAILURE
	blackboard.set_var(store_var, position)
	return SUCCESS
