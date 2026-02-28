class_name GrappleDetector extends Area3D

@onready var player = $".."
var interactibles_in_range: Array[Node3D] = []

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group(&"grapple_points"):
		interactibles_in_range.append(area)

func _on_area_exited(area: Area3D) -> void:
	interactibles_in_range.erase(area)

func get_closest_grapple_point():
	var forward = player.basis.z
	forward.y = player._camera_pivot.basis.z.y

	var closest = 0
	var best: Vector3 = Vector3.ZERO
	for d in interactibles_in_range:
		var direction = (player.global_position - d.global_position).normalized()
		var player_looking_at = forward.dot(direction)
		
		if player_looking_at > 0.5 and player_looking_at > closest:
			print("height ", player.get_height())
			var grapple_position = Vector3(d.global_position)
			grapple_position.y += player.get_height()
			
			var height_adjusted_direction = (player.global_position - grapple_position).normalized()
			
			closest = player_looking_at
			best = -height_adjusted_direction
	
	if best and closest > 0.95 and closest < 1.1:
		return best
