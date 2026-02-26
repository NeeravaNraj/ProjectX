class_name Weapon extends Node

@export_category("Weapon stats")
@export var attack_damage: int = 10
@export var attack_speed: float = 0.05

@export var attack_area: Area3D
@export var attack_area_shape: CollisionShape3D

var _can_attack := true

func attack():
	if not _can_attack: return
	
func start_timer():
	_can_attack = false
	await get_tree().create_timer(attack_speed).timeout
	_can_attack = true
