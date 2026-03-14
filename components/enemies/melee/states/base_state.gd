class_name MeleeEnemyState extends Node

var melee_enemy: MeleeEnemy

func _ready() -> void:
	if %StateActors and %StateActors is MeleeEnemyStateActor:
		melee_enemy = %StateActors.melee_enemy
