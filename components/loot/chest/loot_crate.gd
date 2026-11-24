class_name LootCrate extends StaticBody3D


@onready var animation_player: AnimationPlayer = $Model/AnimationPlayer

var item_scene = preload("res://components/loot/items/item.tscn")

var _opened := false

func open():
    if _opened: return
    _opened = true
    _launch_item()
    animation_player.play(&"OpenChest")

func _launch_item():
    var item: Item = item_scene.instantiate()
    add_child(item)
    item.ground_detector.add_exception_rid(get_rid())
    item.global_position = global_position + Vector3.UP * 0.2
    item.linear_velocity = _item_launch_velocity()
    
func _item_launch_velocity():
    return PhysicsUtils.calculate_ballistic_launch_velocity(to_global(Vector3.RIGHT), global_position, 1)