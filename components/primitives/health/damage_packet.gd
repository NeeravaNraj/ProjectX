class_name DamagePacket extends RefCounted

var attack_direction: Vector3 = Vector3.ZERO

var flat_damage: float
var flat_damage_multiplier: float = 1.0

var base_knockback: float = 1.5

# From items and other possibly sources
var knockback_modifier: float = 0.0
var flat_damage_modifier: float = 0.0


func _init(
	p_flat_damage: float,
	p_flat_damage_modifier: float = 0.0,
	p_flat_damage_multiplier: float = 0.0,
	p_attack_direction: Vector3 = Vector3.ZERO,
	p_knockback_modifier: float = 20.0,
) -> void:
	flat_damage = p_flat_damage
	flat_damage_multiplier = p_flat_damage_multiplier
	
	knockback_modifier = p_knockback_modifier
	flat_damage_modifier = p_flat_damage_modifier
	
	attack_direction = p_attack_direction
