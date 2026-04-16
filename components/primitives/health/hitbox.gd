class_name HitBox extends Area3D

@export var auto_hit: bool = false
@export var exclude: Array[CollisionObject3D]

signal hit(hurtbox: HurtBox, packet: DamagePacket)

var default_packet: DamagePacket

func _ready() -> void:
	if auto_hit:
		area_entered.connect(_on_area_entered)

func attack(packet: DamagePacket):
	for body in get_overlapping_areas():
		var hurtbox = body as HurtBox
		if hurtbox in exclude: continue
		
		if hurtbox:
			hurtbox.damage(packet)
			hit.emit(hurtbox, packet)


func _on_area_entered(area: Area3D) -> void:
	if default_packet: attack(default_packet)
