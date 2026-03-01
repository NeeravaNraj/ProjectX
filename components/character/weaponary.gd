extends Node3D

@onready var player = $".."


func _process(delta: float) -> void:
	global_position = player.get_global_transform_interpolated().origin
