extends ProgressBar

@onready var health_component = $"../../../../Stats/Health"

func _ready() -> void:
	max_value = health_component.max_health
	value = health_component.health

func _on_health_changed(health: int) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "value", health, 0.2)
