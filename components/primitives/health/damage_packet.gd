class_name DamagePacket extends RefCounted

var attack_direction: Vector3 = Vector3.ZERO

var damage: float

var base_knockback: float = 1.5

# From items and other possibly sources
var knockback_modifier: float = 0.0
var flat_damage_modifier: float = 0.0


func _init(
	p_damage: float,
	p_knockback_modifier: float = 20.0,
	p_attack_direction: Vector3 = Vector3.ZERO,
) -> void:
	damage = p_damage
	attack_direction = p_attack_direction
	knockback_modifier = p_knockback_modifier
