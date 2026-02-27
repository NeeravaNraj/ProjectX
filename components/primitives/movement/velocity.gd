class_name VelocityComponent extends Node

@export_range(0.0, 1000.0, 0.01, "or_greater", "hide_control") var max_speed: float = 10.0
@export var acceleration_coef: float = 20
@export var deceleration_coef: float = 30
@export var gravity := -9.8

var target: CharacterBody3D
var raw_direction := Vector2.ZERO
var move_velocity := Vector3.ZERO
var last_moved_direction := Vector3.ZERO

func add_impulse(direction: Vector3, power: float):
	target.velocity += direction.normalized() * power

func _ready() -> void:
	target = get_parent() as CharacterBody3D
	assert(target, "Expected VelocityComponent to be child of CharacterBody3D - %s" % [str(get_path())])
	
func _physics_process(delta: float) -> void:
	move(delta)
	
	raw_direction = Vector2.ZERO 
	target.move_and_slide()

func move(delta: float):
	if not target.is_on_floor():
		target.velocity.y += gravity * delta
		
	var current_velocity = Vector2(move_velocity.x, move_velocity.z)
	var direction = (target.transform.basis * Vector3(raw_direction.x, 0, raw_direction.y)).normalized()
	
	if direction:
		current_velocity = lerp(current_velocity, Vector2(direction.x, direction.z) * max_speed, acceleration_coef * delta)
	else:
		current_velocity = current_velocity.move_toward(Vector2.ZERO, deceleration_coef * delta)
	
	move_velocity = Vector3(current_velocity.x, target.velocity.y, current_velocity.y)
	target.velocity = move_velocity
