extends Node3D

@onready var player = $".."

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and 
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)

	if is_camera_motion:
		player.rotation.y -= event.relative.x * player.mouse_sens
		
		rotation.x += -event.relative.y * player.mouse_sens
		rotation.x = clamp(rotation.x, deg_to_rad(-80), deg_to_rad(90))
