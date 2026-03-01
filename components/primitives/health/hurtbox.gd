class_name HurtBox extends Area3D

@export var health_component: Health
@export var reaction_handler: ReactionHandler

func _ready() -> void:
	assert(health_component, "HurtBox requires reference to a Health component to work - %s" % [str(get_path())])

func damage(packet: DamagePacket):
	var amount = _resolve_damage_packet(packet)
	health_component.damage(amount)

func _resolve_damage_packet(packet: DamagePacket):
	var amount = packet.flat_damage
	var reaction = reaction_handler.apply_element_state(packet.element)
	
	if reaction != null:
		packet.consolidate_conditional_multipliers(reaction.elements)
		amount *= packet.base_reaction_multiplier * (1.0 + packet.reaction_multiplier)
	
	return amount
