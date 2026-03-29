class_name Weapon extends Node

@export_category("Weapon stats")
@export var attack_damage: float = 10
@export var attack_damage_modifier: float = 0
@export var attack_damage_multiplier: float = 0

@export var attack_speed: float = 0.05
@export var attack_speed_modifier: float = 0.0

@export var attack_area_shape: CollisionShape3D
