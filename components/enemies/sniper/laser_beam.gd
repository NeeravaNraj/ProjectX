class_name LaserBeam extends Node3D

@export var enabled: bool = true
@export var max_laser_length: float = 10000.0

@onready var space_state = get_world_3d().direct_space_state
@onready var beam_mesh = $BeamMesh


func _physics_process(delta: float) -> void:
	if not self.enabled:
		if self.visible: self.visible = false
		return

	if not self.visible: self.visible = true

	var from = global_position
	var to = global_position + (-global_transform.basis.z * max_laser_length)
	var query = PhysicsRayQueryParameters3D.create(from, to)

	var result = self.space_state.intersect_ray(query)

	var laser_length = self.max_laser_length
	if result:
		laser_length = (result.position - self.global_position).length()

	self.beam_mesh.position.z = -laser_length
	self.beam_mesh.scale.y = laser_length * 2.0
