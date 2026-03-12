class_name PickupRegion extends Area3D

@onready var player = $"../.."

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(&"pickup"):
		player.add_item(body.get_parent())
