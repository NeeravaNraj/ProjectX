class_name PlayerState extends Node

var player: Player

func _ready() -> void:
	if %StateActors and %StateActors is StateActor:
		player = %StateActors.player
