@tool
extends BTDecorator
	

func _tick(delta: float) -> Status:
	var direction = agent.get_movement_direction()
	direction.y = 0.0
	
	if direction.length() > 0.001:
		agent.look_at(agent.global_position + direction, Vector3.UP)
	
	return get_child(0).execute(delta)
