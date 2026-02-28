class_name GrapplePoint extends Node3D

@onready var detector := $Detector

func _ready() -> void:
	detector.add_to_group(&"grapple_points")
