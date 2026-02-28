class_name BaseLevel extends Node3D

@export_category("PlayerInfo")
@export var spawn_point: Node3D


func _ready() -> void:
	assert(spawn_point, "Level requires spawn_point to be set %s" % [str(get_path())])
