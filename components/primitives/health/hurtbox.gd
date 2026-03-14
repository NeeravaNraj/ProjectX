class_name HurtBox extends Area3D

@export var health_component: Health

func _ready() -> void:
	assert(health_component, "HurtBox requires reference to a Health component to work - %s" % [str(get_path())])

func damage(packet: DamagePacket):
	var amount = _resolve_damage_packet(packet)
	health_component.damage(amount)

func _resolve_damage_packet(packet: DamagePacket):
	var amount = packet.flat_damage

	print("Attack on enemy:")
	print("  Attack Element - %s" % [Element.get_element_name(packet.element)])
	return amount
