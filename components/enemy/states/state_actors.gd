class_name EnemyStateActor extends Node

@export_category("References")
@export var enemy: Enemy


func _on_root_state_physics_processing(delta: float) -> void:
	if not enemy: return
	
	if enemy.player == null:
		enemy.state_chart.send_event(&"onIdle")
