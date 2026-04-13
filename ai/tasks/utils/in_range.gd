@tool
extends BTCondition

@export var max_dist_value: float = 5.0
@export var min_dist_value: float = 0.0
@export var target_var: StringName

var max_squared: float
var min_squared: float

func _setup() -> void:
	max_squared = max_dist_value ** 2
	min_squared = min_dist_value ** 2

func _tick(_delta: float) -> Status:
	var target = blackboard.get_var(target_var, null)
	
	if not is_instance_valid(target):
		return FAILURE
	
	var dist = agent.global_position.distance_squared_to(target.global_position)
	
	if not Utils.in_range(dist, min_squared, max_squared):
		return FAILURE
	
	return SUCCESS
