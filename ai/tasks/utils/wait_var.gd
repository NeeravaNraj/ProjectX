@tool
extends BTAction

@export var duration_var: StringName = &""
@export var default_value: float = 1.0

var duration: float

func _enter() -> void:
	duration = blackboard.get_var(duration_var, default_value)
	assert(typeof(duration) == TYPE_FLOAT)


func _tick(_delta: float) -> Status:
	if get_elapsed_time() < duration:
		return RUNNING
		
	return SUCCESS
