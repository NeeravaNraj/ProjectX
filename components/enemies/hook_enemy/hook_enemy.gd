class_name HookEnemy extends BaseEnemy

@onready var hook_launcher: HookLauncher = $HookLauncher
@onready var attack_range: MeshInstance3D = $AttackRange

var can_move = true

func _ready() -> void:
	init()
	preferred_allies.append_array([MeleeEnemy])
	var shape = attack_range.mesh as SphereMesh
	shape.radius = stats.attack_range
	shape.height = stats.attack_range * 2

func attack():
	var target = predict_next_player_position(stats.aim_prediction_time)
	hook_launcher.shoot(target)
