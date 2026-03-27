class_name HurtBox extends Area3D

@export var health_component: Health

signal hit(packet: DamagePacket)
 
func _ready() -> void:
	assert(health_component, "HurtBox requires reference to a Health component to work - %s" % [str(get_path())])

func damage(packet: DamagePacket):
	var amount = _resolve_damage_packet(packet)
	health_component.damage(amount)
	hit.emit(packet)

func _resolve_damage_packet(packet: DamagePacket):
	return (packet.flat_damage + packet.flat_damage_modifier) * packet.flat_damage_multiplier
