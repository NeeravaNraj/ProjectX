class_name Sniper extends Node3D


@export var range = 10000.0

@onready var space_state = get_world_3d().direct_space_state
@onready var laser_beam: LaserBeam = $LaserOrigin/LaserBeam
@onready var bullet_origin: Marker3D = $BulletOrigin
@onready var bullet_trail_scene = preload("res://components/enemies/sniper/bullet_trail.tscn")

func _ready() -> void:
	self.laser_beam.max_laser_length = self.range


func begin_aiming():
	self.laser_beam.enabled = true

func stop_aiming():
	self.laser_beam.enabled = false

func shoot():
	var wall_collision_layer = Utils.get_collition_layer_by_name(&"world")
	var hurt_box_collision_layer = Utils.get_collition_layer_by_name(&"hurtbox")
	assert(hurt_box_collision_layer)

	var from = self.bullet_origin.global_position
	var to = from + (-self.bullet_origin.global_basis.z * self.range)
	var query = PhysicsRayQueryParameters3D.create(
		from,
		to,
		wall_collision_layer | hurt_box_collision_layer
	)
	query.collide_with_areas = true

	var result = self.space_state.intersect_ray(query)

	var distance = self.range
	var collider = null
	if result:
		distance = self.bullet_origin.global_position.distance_to(
			result.position
		)
		collider = result.collider

	var trail_instance = bullet_trail_scene.instantiate()
	get_tree().current_scene.add_child(trail_instance)
	trail_instance.global_transform = self.bullet_origin.global_transform
	trail_instance.trail_length = distance * 2.0

	return collider as HurtBox
