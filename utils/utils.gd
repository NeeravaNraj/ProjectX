class_name Utils extends Node


static func get_collition_layer_by_name(name: String):
	for i in range(1, 33):
		if ProjectSettings.get_setting("layer_names/3d_physics/layer_%d" % i).to_lower() == name.to_lower():
			return 1 << (i - 1)
	return null

static func in_range(value, min, max):
	return value >= min and value <= max

static func evaluate_basic_expression(context: String, expression: String, default_value: Variant, vars: Dictionary = {}) -> Variant:
	var expr := Expression.new()
	var names = vars.keys()
	var values = vars.values()
	var parse_result: int = expr.parse(expression, names)

	if parse_result != OK:
		push_error("(" + context + ") Expression parse error. Tried to parse expression: '" \
			+ expression \
			+ "' but got error: '" + expr.get_error_text() + "'")
		return default_value

	var result = expr.execute(values, null, false)
	if expr.has_execute_failed():
		push_error("(" + context + ") Expression execute error. Tried to run expression: '"  \
			+ expression \
			+ "' but got error: '" + expr.get_error_text() + "'")
		return default_value

	return result

static func path_of(node: Node) -> String:
	if node == null:
		return ""
	if !node.is_inside_tree():
		return node.name + " (not in tree)"
	return str(node.get_path())

static func safe_equals(a, b):
	if a is Object and b is Object:
		if not is_instance_valid(a) or not is_instance_valid(b):
			return false
	return typeof(a) == typeof(b) and a == b
