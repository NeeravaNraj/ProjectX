class_name HitBox extends Area3D

signal hit(hurtbox: HurtBox, amount: float)

@export var damage_amount: int = 5

func _on_hurtbox_entered(hurtbox: HurtBox):
	hurtbox.damage(damage_amount)
	hit.emit(hurtbox, damage_amount)
