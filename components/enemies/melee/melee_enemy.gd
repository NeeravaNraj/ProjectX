class_name MeleeEnemy extends CharacterBody3D

@export var stats: EnemyStats
@export var enabled: bool = true

@onready var enemy_skin = $MeleeEnemySkin
@onready var hurtbox: HurtBox = $Areas/HurtBox
@onready var state_chart: StateChart = %StateChart
@onready var _velocity: VelocityComponent = $VelocityComponent
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var starting_position: Vector3
var speed: float

var player: Player
var last_player_position = null
var hit_direction = Vector3.ZERO

signal alert(current_position: Vector3, player_position: Vector3)

func get_vistion_radius():
	return stats.vision_distance

func get_player_distance():
	if not player: return INF
	var player_position = player.global_position
	return global_position.distance_to(player_position)

func _ready() -> void:
	starting_position = global_position
	state_chart.send_event(&"onIdle")
	player = get_tree().get_first_node_in_group(&"player")

func move_towards_target():
	if navigation_agent.is_navigation_finished(): return
	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var direction = current_agent_position.direction_to(next_path_position)
	enemy_skin.locomotion(MeleeEnemySkin.MovementStates.Running)
	lookat(direction)
	_velocity.set_velocity(direction * speed)

func lookat(dir: Vector3):
	dir.y = 0
	look_at(global_position + dir, Vector3.UP)

func lookat_player():
	if not player: return
	lookat(player.global_position - global_position)

func can_see_player():
	if not player or get_player_distance() > get_vistion_radius(): return
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		global_position,
		player.global_position
	)
	var result = space_state.intersect_ray(query)
	var collider = result.get(&"collider") as Player
	
	return collider

func _on_health_damaged(amount: int) -> void:
	print("Enemy DAMAGED ", amount)

func _on_health_death() -> void:
	queue_free()

func _on_hurt_box_hit(packet: DamagePacket) -> void:
	hit_direction = packet.attack_direction * packet.knockback_modifier
	hit_direction.y += 0.5 * packet.knockback_modifier
	enemy_skin.stagger()
	
