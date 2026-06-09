@tool
extends Node3D


@export var size: Vector2 = Vector2(1.0, 1.0):
	set(value):
		var x_val = max(0.0, value.x)
		var y_val = max(0.0, value.y)
		size = Vector2(x_val, y_val)
		update_tiles()
		self.update_configuration_warnings()


func _ready() -> void:
	update_tiles()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()

	if size.x <= 0.001 or size.y <= 0.001:
		warnings.append("The tile size is too small or zero! The mesh and collision shape will be invisible or broken.")

	return warnings


func update_tiles() -> void:
	if not Engine.is_editor_hint() and not is_inside_tree():
		return

	if not has_node("Mesh") or not has_node("StaticBody/Collider"):
		return

	var mesh_node = get_node("Mesh") as MeshInstance3D
	var collider_node = get_node("StaticBody/Collider") as CollisionShape3D

	if mesh_node.mesh.has_method("set_size"):
		mesh_node.mesh.size = self.size

	if collider_node.shape.has_method("set_size"):
		collider_node.shape.size = Vector3(size.x, collider_node.shape.size.y, size.y)
