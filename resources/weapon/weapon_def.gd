class_name WeaponDefinition extends Resource 


@export var name: StringName
@export var view_scene: PackedScene


@export_category("Weapon stats")
@export var attack_damage: float = 10
@export var attack_speed: float = 0.05
@export var melee_range: Vector3 = Vector3(5.5, 1.5, 3)
@export var near_offset: float = 1.35
@export var vertical_offset: float = 0.3