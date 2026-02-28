class_name GrapplePoint extends Node3D

@onready var detector := $Detector

func _ready() -> void:
	detector.add_to_group(&"grapple_points")

func illuminate(value: float):
	if value > 0.95 and value < 1.1:
		$Billboard.modulate = Color(0.2, 0.7, 0.7, 1.0)
	else:
		$Billboard.modulate = Color(1, 1, 1)
