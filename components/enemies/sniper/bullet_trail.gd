class_name BulletTrail extends Node3D

@onready var trail_mesh = $TrailMesh
var trail_length: float = 0.0:
	set(value):
		trail_length = value
		self.trail_mesh.position.z = -trail_length / 2.0
		self.trail_mesh.mesh.height = trail_length

func _ready() -> void:
	self.fade_out()

func fade_out():
	var mat = trail_mesh.get_active_material(0)
	var tween = create_tween()
	tween.tween_property(mat, "albedo_color:a", 0.0, 1.0)
	tween.tween_callback(self.queue_free)
