class_name SniperEnemy extends BaseEnemy


@onready var aim_pointer: Node3D = $AimPointer
@onready var sniper: Sniper = $AimPointer/Sniper


func _ready() -> void:
	self.init()


func aim():
	if not enabled: return
	var target = predict_next_player_position(stats.aim_prediction_time)
	self.aim_pointer.look_at(target)


func attack():
	if not enabled: return
	var target = predict_next_player_position(stats.aim_prediction_time)
	self.aim_pointer.look_at(target)
	var collider = self.sniper.shoot()
	if collider:
		collider.damage(self.packet)

func _on_health_death() -> void:
	queue_free()
