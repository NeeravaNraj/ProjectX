class_name ElementSelector extends Node

var current_element := Element.ElementKind.Water

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"element_cycler") and not event.is_action_pressed(&"left_ctrl"):
		_cycle_element(1)
	elif event is InputEventKey:
		_handle_key(event)

func _cycle_element(step: int):
	current_element = (current_element + step) % Element.element_keys.size() - 1
	print("Cycling element to %s" % Element.element_keys[current_element])

func _handle_key(event: InputEventKey):
	if event.is_released(): return
	var value = event.keycode - KEY_0 - 1
	var values = Element.element_values
	
	if value >= 0 and value < values.size() - 1:
		current_element = value as Element.ElementKind
		print("Setting current element to: %s" % [Element.element_keys[value]])
