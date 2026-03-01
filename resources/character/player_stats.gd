class_name PlayerStats extends Resource



@export var move_speed_modifier: float = 0.0
@export var move_speed_sprint: float = 4.0:
	get:
		return move_speed_sprint + move_speed_modifier
@export var move_speed: float = 8.0:
	get:
		return move_speed + move_speed_modifier

@export var jump_velocity_modifier: float = 0.0
@export var jump_velocity: float = 10.0:
	get:
		return jump_velocity + jump_velocity_modifier

@export var grapple_time: float = 0.32
