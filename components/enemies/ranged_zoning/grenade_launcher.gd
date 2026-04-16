class_name GrenadeLauncher extends Node3D

@onready var parent: RangedZoningEnemy = $".."
@onready var bullet_spawner: Marker3D = $"../ViewModel/Gun/MeshInstance3D/BulletSpawner"

var grenade_scene = preload("res://components/enemies/ranged_zoning/zoning_grenade.tscn")

var time_to_reach: float = 1.0

func launch(target: Vector3):
	var grenade: ZoningGrenade = grenade_scene.instantiate()
	add_child(grenade)
	grenade.top_level = true
	grenade.bullet_hitbox.exclude.append(parent)
	grenade.add_collision_exception_with(parent)
	grenade.packet = DamagePacket.new(parent.stats.attack_damage)
	grenade.global_position = bullet_spawner.global_position
	grenade.linear_velocity = get_launch_velocity(target)

func get_launch_velocity(target: Vector3):
	var gravity_vector = Utils.get_gravity_vector()
	var starting_position = bullet_spawner.global_position
	var displacement = target - global_position
	
	return (displacement - 0.5 * gravity_vector * time_to_reach ** 2) / time_to_reach

func get_pitch(target: Vector3):
	var shoot_velocity = get_launch_velocity(target)
	var horizontal_velocity = Vector3(shoot_velocity.x, 0.0, shoot_velocity.z).length()
	return atan2(shoot_velocity.y, horizontal_velocity)

func get_projectile_speed(target: Vector3):
	var starting_position = bullet_spawner.global_position
	var distance = starting_position.distance_to(target)
	return distance / time_to_reach
