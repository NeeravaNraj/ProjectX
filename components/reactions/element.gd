class_name Element extends Node

enum ElementKind {
	Water,
	Fire,
	Wind,
	Thunder,
	Earth,
	Ether,
}

static var element_keys = ElementKind.keys()
static var element_values = ElementKind.values()

static func _make_key(a: int, b: int):
	if a < b:
		return Vector2i(a, b)
	return Vector2i(b, a)

static func get_element_name(e: ElementKind):
	return element_keys[e]
