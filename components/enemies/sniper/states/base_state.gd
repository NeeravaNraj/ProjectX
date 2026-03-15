class_name SniperEnemyState extends Node

var sniper_enemy: SniperEnemy

func _ready() -> void:
	if %StateActors and %StateActors is SniperEnemyStateActor:
		sniper_enemy = %StateActors.sniper_enemy
