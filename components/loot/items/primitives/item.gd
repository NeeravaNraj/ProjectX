class_name Item extends RigidBody3D

@export var float_height: float = 0.1
@export var float_speed: float = 2.0
@export var spin_speed: float = 90.0

@onready var ground_detector: RayCast3D = $GroundDetector
@onready var base_y: float = position.y


var time: float = 0.0
var _floating = false

func _process(delta: float) -> void:
	if not _floating: return
	time += delta

	position.y = base_y + sin(time * float_speed) * float_height
	# print(base_y, position.y)
	rotate_y(-deg_to_rad(spin_speed) * delta)


func _physics_process(_delta: float) -> void:
	if _floating: return
	var point = ground_detector.get_collision_point()
	if point:
		_floating = true    
		freeze = true
		base_y = to_local(point).y + float_height * 2
