class_name RangedZoningEnemy extends BaseEnemy

@onready var gun: MeshInstance3D = $ViewModel/Gun
@onready var grenade_launcher: GrenadeLauncher = $GrenadeLaunchCtrl

func _ready() -> void:
	init()

func aim():
	var target = predict_next_player_position(stats.aim_prediction_time)
	var pitch = grenade_launcher.get_pitch(target)
	gun.rotation.x = -pitch

func attack():
	if not enabled: return
	var target = predict_next_player_position(stats.aim_prediction_time)
	grenade_launcher.launch(target)

func _on_health_death() -> void:
	queue_free()
