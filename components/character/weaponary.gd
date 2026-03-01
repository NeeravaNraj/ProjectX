extends Node3D

@onready var player = $".."

func _process(delta: float) -> void:
	global_transform = player.get_global_transform_interpolated()
