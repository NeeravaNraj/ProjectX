class_name PlayerFirstPersonRig extends Node3D

enum MovementStates {
	Idle = 0,
	Running = 1,
	Falling = -1
}
@export var player: CharacterBody3D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var finger_twidle_timer: Timer = $FingerTwidleTimer


func transition_movement(state: MovementStates):
	var tween = create_tween()
	tween.tween_property(animation_tree, "parameters/locomotion/blend_position", float(state), 0.3)

func abort_jump():
	var value = animation_tree.get("parameters/jump_blend/blend_amount")
	if value != 0:
		animation_tree.set("parameters/jump_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	
	if event.is_action_pressed(&"jump"):
		var value = randi_range(0, 1)
		animation_tree.set("parameters/jump_blend/blend_amount", value)
		animation_tree.set("parameters/jump_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	if event.is_action_pressed(&"left_click"):
		var value = randi_range(0, 1)
		animation_tree.set("parameters/attack_blend/blend_amount", 0)
		animation_tree.set("parameters/attack_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	if event.is_action_pressed(&"inspect"):
		animation_tree.set("parameters/inspect_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _physics_process(_delta: float) -> void:
	_play_finger_twidle()

func _play_finger_twidle():
	if not finger_twidle_timer.is_stopped(): return

	var timeout = randf_range(5, 15)
	finger_twidle_timer.wait_time = timeout
	finger_twidle_timer.start()

func _on_finger_twidle_timer_timeout() -> void:
	animation_tree.set("parameters/finger_twidle_onshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
