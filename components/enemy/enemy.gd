extends RigidBody3D


@export var world: Node3D
@export var vision_radius := 10


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	var player_pos = _get_player_position()
	
	if player_pos.distance_to(position) < vision_radius:
		print("IN RANGE !@#!@#!@#!@#!@#!@#")
	else:
		print("NOT IN RANGE AWIDMNMAIWOJDJIAWDJAWD")

func _get_player_position():
	var player: CharacterBody3D = world.get_node("Player")
	return player.position
