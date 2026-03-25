class_name Katana extends Weapon

# TODO: Fix this weaponry shit

var box: BoxShape3D

func _ready() -> void:
	box = attack_area_shape.shape as BoxShape3D
	assert(box, "Expected BoxShape3D for attack area in Katana")
	
	box.size = Vector3(5.5, 1.5, 3)
