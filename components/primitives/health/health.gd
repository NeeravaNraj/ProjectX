class_name Health extends Node

@export_range(0, 100, 1, "or_greater", "hide_control") var max_health: int = 100

var health := max_health:
	set(health_):
		health = clamp(health_, 0.0, max_health)

signal changed(health: int)
signal healed(amount: int)
signal damaged(amount: int)
signal death()

func heal(amount: int):
	if _is_dead(): return
	
	var old_health = health
	health += amount
	
	healed.emit(health - old_health)
	changed.emit(health)

func damage(amount: int):
	if _is_dead(): return
	
	if (health - amount) <= 0:
		death.emit()
	else:
		damaged.emit(amount)
	
	health -= amount
	changed.emit(health)
	
func _is_dead():
	return health <= 0
