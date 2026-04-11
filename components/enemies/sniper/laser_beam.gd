class_name LaserBeam extends Node3D

@onready var beam_mesh = $BeamMesh
var laser_length: float = 0.0

func _physics_process(delta: float) -> void:
	beam_mesh.position.z = -laser_length / 2.0
	beam_mesh.scale.y = laser_length
