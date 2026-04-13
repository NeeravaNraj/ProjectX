@tool
extends BTAction

@export_multiline var text: String = ""
@export var format_args: Array[Variant] = []

func _enter() -> void:
	var var_matcher = RegEx.new()
	var_matcher.compile("\\$(\\w+)")
	
	var final = text
	for m in var_matcher.search_all(text):
		var var_name = m.get_string(1)
		var value = blackboard.get_var(var_name)
		final = final.replace(m.get_string(), str(value))
	
	print(final % format_args)
