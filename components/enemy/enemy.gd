class_name Enemy extends CharacterBody3D


@export var world: Node3D
@export var vision_radius := 10

@onready var hurtbox = $HurtBox

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
	# var player_pos = _get_player_position()
	
	#if player_pos.distance_to(position) < vision_radius:
		#print("IN RANGE !@#!@#!@#!@#!@#!@#")
	#else:
		#print("NOT IN RANGE AWIDMNMAIWOJDJIAWDJAWD")

func _get_player_position():
	var player: CharacterBody3D = world.get_node("Player")
	return player.position


func _on_health_damaged(amount: int) -> void:
	print("Enemy DAMANGED ", amount)


func _on_health_death() -> void:
	print("Enemy DIEDED!")
