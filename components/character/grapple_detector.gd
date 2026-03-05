class_name GrappleDetector extends Area3D

@onready var player = $".."
var interactibles_in_range: Array[Node3D] = []

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group(&"grapple_points"):
		interactibles_in_range.append(area)

func _on_area_exited(area: Area3D) -> void:
	area.get_parent().illuminate(300)
	interactibles_in_range.erase(area)

func _process(delta: float) -> void:
	for d in interactibles_in_range:
		var value = _get_lookat_value(d)
		d.get_parent().illuminate(value)

func get_closest_grapple_point():
	var forward = player.get_forward()

	var closest = INF
	var can_grapple = false
	var best: Vector3 = Vector3.ZERO
	var grapple_point_distance: float = 1.0
	
	for d in interactibles_in_range:
		var gp: GrapplePoint = d.get_parent()
		var head = player._camera_anchor.global_position
		var direction: Vector3 = (head - d.global_position).normalized()
		var angle = rad_to_deg(direction.angle_to(forward))
		
		
		if angle < 25 and angle < closest:
			var grapple_position = Vector3(d.global_position)
			var grapple_direction = direction
			
			if gp.land_on_top:
				grapple_direction = _get_height_adjusted_direction(d)
			
			closest = angle
			best = -grapple_direction
			can_grapple = _raycast_to_grapple(head, d.global_position) == d
			grapple_point_distance = (grapple_position - player.global_position).length()
	
	if can_grapple and best and closest < 25:
		return [best, grapple_point_distance]

func _get_lookat_value(d: Node3D):
	var forward: Vector3 = player.get_forward()
	var head_position = player._camera_anchor.global_position
	var direction: Vector3 = (head_position - d.global_position).normalized()
	var angle = rad_to_deg(forward.angle_to(direction))
	return angle

func _get_height_adjusted_direction(d: Node3D):
	var grapple_position = Vector3(d.global_position)
	grapple_position.y += player.get_height() * 1.5
	
	return (player.global_position - grapple_position).normalized()

func _raycast_to_grapple(from: Vector3, to: Vector3):
	var raycast_query = PhysicsRayQueryParameters3D.create(from, to)
	raycast_query.collide_with_areas = true
	
	var result = player.space_state.intersect_ray(raycast_query)
	var collider = result.get("collider") as Area3D
	
	return collider
