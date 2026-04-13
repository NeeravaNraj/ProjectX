@tool
extends BTAction


func _enter() -> void:
	agent.attack()

func _tick(_delta: float) -> Status:
	return SUCCESS
