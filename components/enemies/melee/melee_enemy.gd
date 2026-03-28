class_name MeleeEnemy extends CharacterBody3D

@export var stats: EnemyStats

@onready var hurtbox: HurtBox = $HurtBox
@onready var hitbox: HitBox = $Areas/HitBox
@onready var state_chart: StateChart = %StateChart
@onready var _velocity: VelocityComponent = $VelocityComponent
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var player_detection_area: Area3D = $Areas/PlayerDetectionArea
@onready var detection_shape: CollisionShape3D = $Areas/PlayerDetectionArea/PlayerDetectionShape

var starting_position: Vector3
var speed: float

var player: Variant = null
var last_player_position = null
var hit_direction = Vector3.ZERO

signal alert(current_position: Vector3, player_position: Vector3)

func get_vistion_radius():
	var shape = detection_shape.shape as SphereShape3D
	return shape.radius

func get_player_distance():
	if not player: return INF
	var player_position = player.global_position
	return global_position.distance_to(player_position)

func _ready() -> void:
	starting_position = global_position
	state_chart.send_event(&"onIdle")

func move_towards_target():
	if navigation_agent.is_navigation_finished(): return
	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var direction = current_agent_position.direction_to(next_path_position)

	_velocity.set_velocity(direction * speed)

func lookat_player():
	if not player: return
	var dir = player.global_position - global_position
	dir.y = 0
	look_at(global_position + dir, Vector3.UP)

func _on_health_damaged(amount: int) -> void:
	print("Enemy DAMAGED ", amount)


func _on_health_death() -> void:
	queue_free()


func _on_hurt_box_hit(packet: DamagePacket) -> void:
	hit_direction = packet.attack_direction * packet.knockback_modifier
	hit_direction.y += 0.5 * packet.knockback_modifier
	state_chart.send_event(&"onDamaged")
