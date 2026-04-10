extends SniperEnemyState


@onready var aim_timer: Timer = $AimTimer


func _on_aiming_state_entered() -> void:
	sniper_enemy.laser_beam.visible = true
	self.aim_timer.start()

func _on_aiming_state_physics_processing(delta: float) -> void:
	if not sniper_enemy or not sniper_enemy.player: return

	var current_aim = sniper_enemy.laser_beam.global_basis.get_rotation_quaternion()
	var ideal_aim = sniper_enemy.laser_beam.global_transform.looking_at(
		sniper_enemy.player.global_position, Vector3.UP
	).basis.get_rotation_quaternion()

	var new_aim = current_aim.slerp(
		ideal_aim, delta * 15.0
	)

	sniper_enemy.aim_pointer.global_basis = new_aim

	var space_state = sniper_enemy.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		sniper_enemy.global_position,
		sniper_enemy.global_position + sniper_enemy.aim_pointer.global_basis * Vector3(0.0, 0.0, -sniper_enemy.stats.aim_range)
	)
	var result = space_state.intersect_ray(query)

	if result:
		sniper_enemy.laser_beam.laser_length = (result.position - sniper_enemy.global_position).length()
	else:
		sniper_enemy.laser_beam.laser_length = sniper_enemy.stats.aim_range

func _on_aim_timer_timeout() -> void:
	sniper_enemy.state_chart.send_event(&"onShooting")

func _on_aiming_state_exited() -> void:
	sniper_enemy.laser_beam.visible = false
