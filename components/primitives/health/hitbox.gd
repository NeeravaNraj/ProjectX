class_name HitBox extends Area3D

@export var exclude: Array[CollisionObject3D]

signal hit(hurtbox: HurtBox, packet: DamagePacket)

func attack(packet: DamagePacket):
	for body in get_overlapping_areas():
		var hurtbox = body as HurtBox
		if hurtbox in exclude: continue
		
		if hurtbox:
			hurtbox.damage(packet)
			hit.emit(hurtbox, packet)
