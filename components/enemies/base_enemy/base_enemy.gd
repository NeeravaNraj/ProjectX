class_name BaseEnemy extends CharacterBody3D

@export var stats: EnemyStats
@export var enabled: bool = true
@export var avoidance: bool = false

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var velocity_component: VelocityComponent = $VelocityComponent

signal alert(current_position: Vector3, player_position: Vector3)

var player: Player
var packet: DamagePacket
var spawn_transform: Transform3D

var speed: float = 0.0
var last_player_position = null
var last_target_position = null
var space_state: PhysicsDirectSpaceState3D

var nav_map: RID
var nav_map_ready = false
var collider: CollisionShape3D
var avoidance_component: EnemyAvoidance

var preferred_allies: Array

func get_vistion_radius():
	return stats.vision_distance

func get_player_distance():
	if not player: return INF
	var player_position = player.global_position
	return global_position.distance_to(player_position)

func get_forward():
	return transform.basis.z.normalized()

func get_movement_direction():
	return velocity.normalized() * Vector3(1.0, 0, 1.0)

func get_position_near_ally():
	var best = null
	var score = -INF
	
	for ally in Utils.get_in_range_from_group(self, &"enemy", stats.preferred_ally_distance):
		if not _is_preferred_ally(ally): continue
		var distance = global_position.distance_to(ally.global_position)
		var player_distance = get_player_distance()
		var ally_score = -distance + -player_distance * 0.5
		
		if ally_score > score:
			score = ally_score
			var direction = global_position.direction_to(ally.global_position)
			best = direction * max(distance - stats.min_distance_from_target, 0.0)
	
	return best

func predict_next_player_position(t: float):
	return player.global_position + (player.velocity * t)

func can_attack_player():
	return get_player_distance() < stats.attack_range

func can_see_player():
	if not player or get_player_distance() > get_vistion_radius(): return null
	var query = PhysicsRayQueryParameters3D.create(
		global_position,
		player.global_position
	)
	var result = space_state.intersect_ray(query)
	var collider = result.get(&"collider") as Player
	
	return collider

func set_navigation_target_position(target: Vector3):
	last_target_position = target
	navigation_agent.target_position = target

func set_navigation_target(node: Node3D):
	set_navigation_target_position(node.global_position)

func set_navigation_target_to_player():
	last_player_position = player.position
	set_navigation_target(player)

func move_towards_target():
	if navigation_agent.is_navigation_finished(): return false
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_position)
	direction.y = 0.0

	velocity_component.set_velocity(direction * speed)
	return true

func _physics_process(_delta: float) -> void:
	if avoidance:
		avoidance_component.perform_avoidance()

func init() -> void:
	spawn_transform = transform
	space_state = get_world_3d().direct_space_state
	packet = DamagePacket.new(stats.attack_damage)
	navigation_agent.target_desired_distance = stats.min_distance_from_target
	player = get_tree().get_first_node_in_group(&"player")
	avoidance_component = EnemyAvoidance.new(self)
	
	nav_map = get_world_3d().navigation_map
	NavigationServer3D.map_changed.connect(_on_nav_ready)
	
	if avoidance:
		avoidance_component.init_avoidance()
	
	if not enabled:
		process_mode = Node.PROCESS_MODE_DISABLED
		
	assert(player, "Expected player to be in 'player' group.")

func _on_nav_ready(map_rid):
	nav_map_ready = true

func _is_preferred_ally(node: Node3D):
	for t in preferred_allies:
		if is_instance_of(node, t):
			return true
	return false
