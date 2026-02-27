class_name Katana extends Weapon

var box: BoxShape3D

func _ready() -> void:
	box = attack_area_shape.shape as BoxShape3D
	assert(box, "Expected BoxShape3D for attack area in Katana")
	
	box.size = Vector3(2.5, 1, 2)
