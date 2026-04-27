class_name HookLauncher extends Node3D

@onready var hook_enemy: HookEnemy = $".."
@onready var hurt_box: HurtBox = $"../HurtBox"
@onready var hook: Hook = $Hook
@onready var chain: Line3D = $Chain
@onready var reel_in_timer: Timer = $ReelInTimer

var target_location: Vector3 = Vector3.ZERO:
	set(value):
		t = 0.0
		target_location = value
var target_distance: float = 0.0
var distance_to_target: float = 0.0
var hook_speed: float = 0.5

var can_reset = true
var t: float = 0.0
var hook_range: float
var original_rotation: Vector3
var look_at_direction: Vector3

func _ready() -> void:
	target_location = global_position
	original_rotation = hook.rotation
	hook_range = hook_enemy.stats.attack_range
	
	hook.hit_box.exclude.append(hurt_box)
	hook.setup_hitbox(hook_enemy.stats.attack_damage)

func shoot(target: Vector3):
	target_location = target
	target_distance = _get_distance_to_target()
	look_at_direction = (global_position - target_location).normalized()
	hook_enemy.can_move = false

func reel_in():
	can_reset = true
	target_location = hook_enemy.global_position

func _physics_process(delta: float) -> void:
	_extend_chain()
	_move_towards_target(delta)
	_reel_in()
	
	if can_reset:
		_release()
		_reset()

func _get_distance_to_target():
	return min((global_position - target_location).length(), hook_enemy.stats.attack_range)

func _move_towards_target(delta: float):
	t += delta * hook_speed
	t = clampf(t, 0, 1)
	
	var eased_t = ease(t, 0.75)
	
	if target_location != global_position and distance_to_target > 1.0:
		hook.look_at(hook.global_position + look_at_direction, Vector3.UP)
	
	if hook_enemy.can_move:
		target_location = global_position
	
	hook.origin = global_position
	hook.global_position = hook.global_position.lerp(target_location, eased_t)
	distance_to_target = hook.global_position.distance_to(target_location)

func _reel_in():
	if distance_to_target < 1.0:
		if reel_in_timer.is_stopped():
			reel_in_timer.start()
	elif not reel_in_timer.is_stopped():
		reel_in_timer.stop()

func _release():
	if distance_to_target < hook_enemy.stats.min_distance_from_target:
		hook.release()

func _reset():
	if distance_to_target > 1: return
	
	can_reset = false
	chain.visible = false
	hook_enemy.can_move = true
	hook.position = Vector3.ZERO
	hook.rotation = original_rotation
	chain.endpoint = to_local(Vector3.ZERO)

func _on_reel_in_timer_timeout() -> void:
	reel_in()

func _extend_chain():
	if distance_to_target < 0.1: return
	
	chain.visible = true
	chain.endpoint = to_local(hook.global_position)
