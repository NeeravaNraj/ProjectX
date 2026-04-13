@tool
extends BTAction

var speed: float = 1.0

func _enter() -> void:
	speed = blackboard.get_var(&"move_speed")

func _tick(_delta: float) -> Status:
	var target = blackboard.get_var(&"target_position")
	agent.set_navigation_target_position(target)
	agent.speed = speed
	var moved = agent.move_towards_target()
	
	if moved: return RUNNING
	return SUCCESS
