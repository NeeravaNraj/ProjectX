@tool
extends BTAction

@export var property_path: String
@export var target_var_name: StringName

@export var load_on_tick: bool = false

func _enter() -> void:
	_load()

func _tick(_delta: float) -> Status:
	if not load_on_tick: return SUCCESS
	_load()
	return SUCCESS

func _load():
	var value = agent.get_indexed(property_path)
	blackboard.set_var(target_var_name, value)

func _generate_name() -> String:
	return "Load '%s' from agent into '%s'" % [property_path, target_var_name]
