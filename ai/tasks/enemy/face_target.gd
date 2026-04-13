@tool
extends BTDecorator
	

func _tick(delta: float) -> Status:
	var target = blackboard.get_var(&"target_position")
	if target == null: return FAILURE
	var direction = (target - agent.global_position)
	direction.y = 0.0
	agent.look_at(agent.global_position + direction, Vector3.UP)
	
	return get_child(0).execute(delta)
