@tool
extends BTAction

@export var source: StringName
@export var target: StringName

func _enter() -> void:
	var value = blackboard.get_var(source)
	blackboard.set_var(target, value)

func _tick(_delta: float) -> Status:
	return SUCCESS
