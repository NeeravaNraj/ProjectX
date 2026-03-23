class_name HealthBar extends Node3D

@export var health_component: Health

@onready var progress_bar = $SubViewport/TextureProgressBar

func _ready() -> void:
	assert(health_component, "HealthComponent required for Healthbar - [%s]" % [str(get_path())])
	progress_bar.value = health_component.health
	health_component.changed.connect(on_health_change)

func on_health_change(health: int):
	progress_bar.value = health
