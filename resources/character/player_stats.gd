class_name PlayerStats extends Resource



@export var move_speed_modifier: float = 0.0
@export var move_speed: float = 12.0:
	get:
		return move_speed + move_speed_modifier
@export var move_speed_dash: float = 65.0

@export var jump_velocity_modifier: float = 0.0
@export var jump_velocity: float = 12.0:
	get:
		return jump_velocity + jump_velocity_modifier

@export var wall_run_jump_velocity: float = 16.0

@export var grapple_time: float = 0.32
@export var max_grapple_speed: float = 38.0
@export var min_grapple_speed: float = 30.0 

@export var idle_energy_growth_factor: float = -0.1
@export var movement_energy_growth_factor: float = 0.025
@export var dash_energy_growth_factor: float = 0.05
@export var jump_energy_growth_factor: float = 0.06
@export var wall_run_energy_growth_factor: float = 0.08
@export var grapple_energy_growth_factor: float = 0.1
