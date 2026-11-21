class_name HurtBox extends Area3D

@export var health_component: Health

signal hit(packet: DamagePacket)
 
func _ready() -> void:
	assert(health_component, "HurtBox requires reference to a Health component to work - %s" % [str(get_path())])

func damage(packet: DamagePacket):
	health_component.damage(int(packet.damage))
	hit.emit(packet)
