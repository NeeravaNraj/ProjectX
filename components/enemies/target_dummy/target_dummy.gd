class_name TargetDummy extends Node3D

@onready var health: Health = $Health

func _on_hurt_box_hit(packet: DamagePacket) -> void:
    health.heal(packet.damage)
    print("Hit: Damage '%f'" % packet.damage)
