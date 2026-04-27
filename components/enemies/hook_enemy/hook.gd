class_name Hook extends Node3D

@onready var hit_box: HitBox = $HitBox
@onready var hook_arm: MeshInstance3D = $ViewModel/HookArm

var origin: Vector3
var hooked_body: Node3D = null

func setup_hitbox(damage: float):
	var packet = DamagePacket.new(damage)
	hit_box.default_packet = packet
	hit_box.auto_hit = true

func release():
	hooked_body = null

func _drag():
	if not hooked_body: return
	hooked_body.global_position = global_position

func _physics_process(_delta: float) -> void:
	_drag()

func _on_hook_box_body_entered(body: Node3D) -> void:
	hooked_body = body
	global_position = body.global_position
