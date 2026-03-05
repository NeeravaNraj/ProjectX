class_name GrapplePoint extends Node3D

@export var land_on_top := true
@export var omnidirectional := false

@onready var detector := $Detector

func _ready() -> void:
	detector.add_to_group(&"grapple_points")

func illuminate(angle: float):
	var tween = create_tween()
	if angle < 25:
		tween.tween_property($Billboard, "modulate", Color(0.2, 0.7, 0.7, 1.0), 0.3)
	else:
		tween.tween_property($Billboard, "modulate", Color(1, 1, 1), 0.3)
