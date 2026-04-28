@tool
extends BTDecorator
@export var tween_duration: float = 0.1

func _tick(delta: float) -> Status:
	var target = blackboard.get_var(&"target_position")
	if target == null: return FAILURE
	
	agent.look_at_target(target, tween_duration)
	
	return get_child(0).execute(delta)
