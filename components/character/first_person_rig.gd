class_name PlayerFirstPersonRig extends Node3D

enum MovementStates {
	Idle = 0,
	Running = 1,
	Falling = -1
}

@onready var animation_tree: AnimationTree = $AnimationTree


func transition_movement(state: MovementStates):
	var tween = create_tween()
	tween.tween_property(animation_tree, "parameters/locomotion/blend_position", float(state), 0.3)

func abort_jump():
	var value = animation_tree.get("parameters/jump_blend/blend_amount")
	if value == 1.0:
		animation_tree.set("parameters/blade_spin_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	
	if event.is_action_pressed(&"jump"):
		var value = randi_range(0, 1)
		animation_tree.set("parameters/jump_blend/blend_amount", value)
		animation_tree.set("parameters/blade_spin_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	if event.is_action_pressed(&"left_click"):
		var value = randi_range(0, 1)
		animation_tree.set("parameters/attack_blend/blend_amount", value)
		animation_tree.set("parameters/attack_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		await _play_return_animation()

func _play_return_animation():
	await get_tree().create_timer(0.3).timeout
	animation_tree.set("parameters/return_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
