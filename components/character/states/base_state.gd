class_name PlayerState extends Node

var player: Player
var stats: StatsComponent

func _ready() -> void:
	if %StateActors and %StateActors is PlayerStateActor:
		player = %StateActors.player
		stats = %StateActors.stats