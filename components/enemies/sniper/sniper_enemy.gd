class_name SniperEnemy extends BaseEnemy


@onready var aim_pointer: Node3D = $AimPointer
@onready var sniper: Sniper = $AimPointer/Sniper


func _ready() -> void:
	self.init()


func begin_aiming():
	if not enabled: return
	self.sniper.begin_aiming()


func stop_aiming():
	if not enabled: return
	self.sniper.stop_aiming()


func aim():
	if not enabled: return
	var target = predict_next_player_position(stats.aim_prediction_time)
	var old_rot = self.aim_pointer.rotation
	self.aim_pointer.look_at(target)
	var new_rot = self.aim_pointer.rotation
	var slerped = old_rot.slerp(new_rot, 1.0)
	self.aim_pointer.rotation = slerped


func attack():
	if not enabled: return
	var collider = self.sniper.shoot()
	if collider:
		collider.damage(self.packet)

func _on_health_death() -> void:
	queue_free()
