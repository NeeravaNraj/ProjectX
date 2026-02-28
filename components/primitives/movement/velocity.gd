class_name VelocityComponent extends Node

@export_range(0.0, 1000.0, 0.01, "or_greater", "hide_control") var speed: float = 8.0
@export var acceleration_coef: float = 20
@export var deceleration_coef: float = 30
@export var gravity := -9.8

var speed_modifier: float = 0.0

var target: CharacterBody3D
var raw_direction := Vector2.ZERO
var move_velocity := Vector3.ZERO
var last_moved_direction := Vector3.ZERO

func add_impulse(direction: Vector3, power: float):
	target.velocity += direction.normalized() * power

func set_speed_modifier(value: float):
	speed_modifier = clampf(value, -1e7, 1e7)

func _ready() -> void:
	target = get_parent() as CharacterBody3D
	assert(target, "Expected VelocityComponent to be child of CharacterBody3D - %s" % [str(get_path())])
	
func _physics_process(delta: float) -> void:
	if not target.is_on_floor():
		target.velocity.y += gravity * delta
		
	var current_velocity = Vector2(move_velocity.x, move_velocity.z)
	var direction = (target.transform.basis * Vector3(raw_direction.x, 0, raw_direction.y)).normalized()
	
	var final_speed = speed + speed_modifier
	var acceleration = acceleration_coef * delta
	var deceleration = deceleration_coef * delta
	
	if direction:
		var speed_scaled_direction = Vector2(direction.x, direction.z) * final_speed
		current_velocity = lerp(current_velocity, speed_scaled_direction, acceleration)
	else:
		current_velocity = current_velocity.move_toward(Vector2.ZERO, deceleration)
	
	move_velocity = Vector3(current_velocity.x, target.velocity.y, current_velocity.y)
	target.velocity = move_velocity
	
	target.move_and_slide()
