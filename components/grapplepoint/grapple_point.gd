class_name GrapplePoint extends Node3D

@export var land_on_top := true
@onready var detector := $Detector

func _ready() -> void:
	detector.add_to_group(&"grapple_points")

func illuminate(angle: float):
	if angle < 25:
		$Billboard.modulate = Color(0.2, 0.7, 0.7, 1.0)
	else:
		$Billboard.modulate = Color(1, 1, 1)
