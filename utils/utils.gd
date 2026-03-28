class_name Utils extends Node


static func get_collition_layer_by_name(name: String):
	for i in range(1, 33):
		if ProjectSettings.get_setting("layer_names/3d_physics/layer_%d" % i).to_lower() == name.to_lower():
			return 1 << (i - 1)
	return null

static func in_range(value, min, max):
	return value >= min and value <= max
