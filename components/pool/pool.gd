class_name Pool extends Node

@export var scene: PackedScene
@export var capacity := 8

var objects: Array[Variant] = []

func _ready() -> void:
	_add_objects()

func get_object():
	if objects.size() == 0:
		_add_objects()
	return objects.pop_front()

func return_object(object: Variant):
	object.visible = false
	objects.append(object)

func _add_objects():
	for i in range(capacity):
		var object = scene.instantiate()
		object.visible = false
		objects.append(object)
