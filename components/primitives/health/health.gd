class_name Health extends Node

@export var health: int = 50

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
	
	if (health - amount) < 0:
		health = 0
		death.emit()
	else:
		health -= amount
		damaged.emit(amount)

	changed.emit(health)
	
func _is_dead():
	return health <= 0
