@tool
extends BaseLevel


@onready var grapple_points = $GrapplePoints
var grapple_point_scene = preload("res://components/grapplepoint/grapple_point.tscn")

func _ready() -> void:
	replace_nodes_with_scene(grapple_points, grapple_point_scene)
