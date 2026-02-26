class_name VelocityComponent extends Node

@export_range(0.0, 1000.0, 0.01, "or_greater", "hide_control") var max_speed: float = 10.0
@export var acceleration_coef: float = 50.0
@export var deceleration_coef: float = 50.0
@export var gravity := -30.0

var target: CharacterBody3D
var raw_direction := Vector2.ZERO
var move_direction := Vector3.ZERO
var last_moved_direction := Vector3.ZERO

func add_impulse(direction: Vector3, power: float):
	target.velocity += direction.normalized() * power

func _ready() -> void:
	target = get_parent() as CharacterBody3D
	assert(target, "Expected VelocityComponent to be child of CharacterBody3D - %s" % [str(get_path())])
	
func _physics_process(delta: float) -> void:
	_accelerate(delta)
	_fall(delta)
	
	raw_direction = Vector2.ZERO
	target.move_and_slide()
	last_moved_direction = move_direction

func _accelerate(delta: float):
	var forward = target.global_basis.z
	var right = target.global_basis.x
	var rate = acceleration_coef * delta
	
	move_direction = forward * raw_direction.y + right * raw_direction.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	target.velocity = target.velocity.move_toward(move_direction * max_speed, rate)
	
func _fall(delta: float):
	var y_velocity := target.velocity.y
	target.velocity.y = 0.0
	target.velocity.y = y_velocity + gravity * delta
