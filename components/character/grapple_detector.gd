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
	var best: Vector3 = Vector3.ZERO
	var grapple_point_distance: float = 1.0
	
	for d in interactibles_in_range:
		var direction: Vector3 = (player.global_position - d.global_position).normalized()
		var angle = rad_to_deg(direction.angle_to(forward))
		
		if angle < 25 and angle < closest:
			var grapple_position = Vector3(d.global_position)
			grapple_position.y += player.get_height()
			
			var height_adjusted_direction = (player.global_position - grapple_position).normalized()
			
			closest = angle
			best = -height_adjusted_direction
			grapple_point_distance = (grapple_position - player.global_position).length()
	
	if best and closest < 25:
		return [best, grapple_point_distance]

func _get_lookat_value(d: Node3D):
	var forward: Vector3 = player.get_forward()
	var direction: Vector3 = (player.global_position - d.global_position).normalized()	
	var angle = rad_to_deg(direction.angle_to(forward))
	return angle
