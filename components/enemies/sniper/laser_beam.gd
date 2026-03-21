class_name LaserBeam extends Node3D

@onready var beam_mesh = $BeamMesh
var laser_length: float = 0.0

func _process(_delta: float) -> void:
	self.beam_mesh.position.z = -self.laser_length / 2.0
	self.beam_mesh.mesh.height = self.laser_length
