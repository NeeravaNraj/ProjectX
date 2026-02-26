class_name HurtBox extends Area3D

@export var health_component: Health

func _ready() -> void:
	assert(health_component, "HurtBox requires reference to a Health component to work - %s" % [str(get_path())])

func damage(amount: int):
	health_component.damage(amount)
