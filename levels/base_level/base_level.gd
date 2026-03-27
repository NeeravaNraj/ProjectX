@tool
class_name BaseLevel extends Node3D

func replace_nodes_with_scene(node: Node3D, scene: PackedScene):
	for child in node.get_children():
		var object = scene.instantiate()
		child.add_child(object)
