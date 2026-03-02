class_name EnemyState extends Node

var enemy: Enemy

func _ready() -> void:
	if %StateActors and %StateActors is EnemyStateActor:
		enemy = %StateActors.enemy
