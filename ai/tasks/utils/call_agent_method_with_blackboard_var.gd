@tool
extends BTAction

@export var method_name: StringName
@export var blackboard_vars: Array[StringName]

func _enter() -> void:
	var method = Callable(agent, method_name)
	var arguments = []
	for v in blackboard_vars:
		arguments.append(blackboard.get_var(v))
	method.callv(arguments)

func _generate_name() -> String:
	return "Call '%s()' using blackboard variable(s) '%s'" % [method_name, ", ".join(blackboard_vars)]

func _tick(_delta: float) -> Status:
	return SUCCESS
