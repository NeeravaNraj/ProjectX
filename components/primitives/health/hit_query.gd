class_name HitQuery3D extends RefCounted

static var hurtbox_mask: int = Utils.get_collition_layer_by_name("HurtBox")

static func query_box(
	space: PhysicsDirectSpaceState3D,
	query_transform: Transform3D,
	size: Vector3,
	exclude: Array[RID] = [],
	max_results := 32,
) -> Array[HurtBox]:
	var nodes = PhysicsUtils.query_box_collision(space, query_transform, size, hurtbox_mask, exclude, max_results)
	var hurtboxes: Array[HurtBox] = []
	
	for node in nodes:
		if node is HurtBox: hurtboxes.append(node)
	
	return hurtboxes
