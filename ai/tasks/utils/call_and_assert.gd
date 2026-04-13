@tool
extends BTCondition

@export var method_name: StringName
@export var arguments: Array[Variant]
@export var assert_not: bool = false
@export_multiline var assert_expression: String = "null"


var method: Callable
var assert_value: Variant

func _setup() -> void:
	method = Callable(agent, method_name)
	var vars = blackboard.get_vars_as_dict()
	var context = "Assert call '%s' to be '%s'" % [method_name, assert_expression]
	assert_value = Utils.evaluate_basic_expression(context, assert_expression, null, vars)

func _generate_name() -> String:
	var does_not = "not " if assert_not else ""
	return "Call '%s()' and assert that it does %sreturn '%s'" % [method_name, does_not, assert_expression]

func _tick(_delta: float) -> Status:
	var value = method.call()
	var equals = value == assert_value
	
	if (assert_not and not equals) or (not assert_not and equals):
		return SUCCESS
	
	return FAILURE
