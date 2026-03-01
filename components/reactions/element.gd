class_name Element extends Node

enum ElementKind {
	Water,
	Fire,
	Wind,
	Thunder,
	Earth,
	Ether,
}

var element_keys = ElementKind.keys()

static func _make_key(a: int, b: int) -> PackedInt32Array:
	if a < b:
		return PackedInt32Array([a, b])
	return PackedInt32Array([b, a])

func get_element_name(e: ElementKind):
	return element_keys[e]
