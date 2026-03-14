class_name PlayerFirstPersonRig extends Node3D

enum MovementStates {
	Idle = 0,
	Running = 1,
	Falling = -1
}
@export var player: CharacterBody3D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var finger_twidle_timer: Timer = $FingerTwidleTimer
@onready var animation_playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")

func transition_movement(state: MovementStates):
	var tween = create_tween()
	tween.tween_property(animation_tree, "parameters/StateMachine/Locomotion/blend_position", float(state), 0.3)

func abort_jump():
	if animation_playback.get_current_node() == &"Parry": return
	animation_tree.set("parameters/StateMachine/conditions/leave_jump", true)
	animation_playback.travel(&"Locomotion")

func parry(value: bool):
	if value:
		animation_tree.set("parameters/StateMachine/conditions/leave_parry", false)
		animation_playback.travel(&"Parry")
	else:
		animation_playback.travel(&"Locomotion")
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	
	if event.is_action_pressed(&"jump"):
		_jump()
		
	if event.is_action_pressed(&"left_click"):
		_attack()	
	
	if event.is_action_pressed(&"inspect"):
		_inspect()

func _physics_process(_delta: float) -> void:
	_play_finger_twidle()

func _play_finger_twidle():
	if not finger_twidle_timer.is_stopped(): return

	var timeout = randf_range(5, 15)
	finger_twidle_timer.wait_time = timeout
	finger_twidle_timer.start()

func _attack():
	var value = randi_range(0, 1)
	animation_tree.set("parameters/StateMachine/Attack/attack_blend/blend_amount", value)
	animation_playback.travel(&"Attack")

func _jump():
	if animation_playback.get_current_node() == &"Parry": return
	var value = randi_range(0, 10)
	if value >= 8:
		animation_playback.travel(&"BladeSpin")
	else:
		animation_tree.set("parameters/StateMachine/conditions/leave_jump", false)
		animation_playback.travel(&"Jumping")

func _inspect():
	animation_playback.travel(&"Inspect")
	
func _fire_oneshot(path: String):
	animation_tree.set(path, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _fade_out_oneshot(path: String):
	animation_tree.set(path, AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)

func _abort_oneshot(path: String):
	animation_tree.set(path, AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)

func _on_finger_twidle_timer_timeout() -> void:
	if animation_playback.get_current_node() == &"Locomotion":
		_fire_oneshot("parameters/finger_twidle_oneshot/request")
