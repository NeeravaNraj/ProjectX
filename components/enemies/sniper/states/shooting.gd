extends SniperEnemyState


@onready var bullet_trail_scene = preload("res://components/enemies/sniper/bullet_trail.tscn")


func _on_shooting_state_entered() -> void:
	print("Shooting...")


func _on_shooting_state_physics_processing(delta: float) -> void:
	var space_state = sniper_enemy.get_world_3d().direct_space_state
	
	var hurt_box_collision_layer = Utils.get_collition_layer_by_name(&"hurtbox")
	assert(hurt_box_collision_layer)
	
	var query = PhysicsRayQueryParameters3D.create(
		sniper_enemy.global_position,
		sniper_enemy.global_position + sniper_enemy.aim_pointer.global_basis * Vector3(0.0, 0.0, -sniper_enemy.stats.aim_range),
		hurt_box_collision_layer
	)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)

	var bullet_trail_instance: BulletTrail = self.bullet_trail_scene.instantiate()
	sniper_enemy.aim_pointer.add_child(bullet_trail_instance)
	
	if result:
		bullet_trail_instance.trail_length = (result.position - sniper_enemy.global_position).length()
		on_hit(result)
	else:
		bullet_trail_instance.trail_length = sniper_enemy.stats.aim_range
		

	sniper_enemy.state_chart.send_event(&"onRepositioning")

func on_hit(result: Dictionary):
	var hurt_box = result.get("collider") as HurtBox

	if hurt_box:
		var packet = DamagePacket.new(sniper_enemy.stats.attack_damage)
		hurt_box.damage(packet)
		print("Hit.")
