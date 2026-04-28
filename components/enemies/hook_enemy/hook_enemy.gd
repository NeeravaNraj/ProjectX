class_name HookEnemy extends BaseEnemy

@onready var hook_launcher: HookLauncher = $HookLauncher

var can_move = true

func _ready() -> void:
	init()
	preferred_allies.append_array([MeleeEnemy])

func attack():
	var target = predict_next_player_position(stats.aim_prediction_time)
	hook_launcher.shoot(target)
