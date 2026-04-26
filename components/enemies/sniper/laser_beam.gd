class_name LaserBeam extends Node3D

@export var enabled: bool = true
@export var max_laser_length: float = 10000.0

@onready var space_state = get_world_3d().direct_space_state
@onready var beam_mesh: MeshInstance3D = $BeamMesh


func _physics_process(delta: float) -> void:
	if not self.enabled:
		if self.visible: self.visible = false
		return

	if not self.visible:
		var material = self.beam_mesh.get_active_material(0)
		material.albedo_color.a = 0.0
		var tween = create_tween()
		tween.tween_property(
			material,
			"albedo_color:a",
			1.0,
			2.5
		)

		self.visible = true

	var from = global_position
	var to = global_position + (-global_transform.basis.z * max_laser_length)
	var query = PhysicsRayQueryParameters3D.create(from, to)

	var result = self.space_state.intersect_ray(query)

	var laser_length = self.max_laser_length
	if result:
		laser_length = (result.position - self.global_position).length()

	self.beam_mesh.position.z = -laser_length
	self.beam_mesh.scale.y = laser_length * 2.0
