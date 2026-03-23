class_name Katana extends Weapon

@onready var player = $"../.."

var box: BoxShape3D

func _ready() -> void:
	box = attack_area_shape.shape as BoxShape3D
	assert(box, "Expected BoxShape3D for attack area in Katana")
	
	box.size = Vector3(4, 1, 3)

func animate_attack():
	pass
