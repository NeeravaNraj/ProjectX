class_name EnemyAvoidance extends Resource

const SIMILARITY_CONSTRAINT = 0.5

var enemy: BaseEnemy
var current_target = null
var original_target_desired_distance: float

func _init(p_enemy: BaseEnemy) -> void:
	enemy = p_enemy

func init_avoidance():
	original_target_desired_distance = enemy.navigation_agent.target_desired_distance
	return

func perform_avoidance():
	var min_distance = enemy.stats.min_distance_from_target
	var neighbours = _get_default_neighbours()
	var neighbour_positions = _build_neighbours(neighbours)
	var separation = Utils.get_separation_direction(enemy.global_position, neighbour_positions, min_distance)
	
	if separation:
		var safe_point = get_random_reachable_point_in_direction(separation * min_distance)
		current_target = safe_point
		enemy.set_navigation_target_position(safe_point)
	
	if current_target and not _move():
		current_target = null

func get_random_reachable_point_in_direction(direction: Vector3) -> Vector3:
	
	if not enemy.nav_map_ready:
		return enemy.global_position
	
	var nav_map = enemy.nav_map
	var origin = enemy.global_position
	var final_direction = origin + direction
	
	var point = NavigationServer3D.map_get_closest_point(nav_map, final_direction)
	var path = NavigationServer3D.map_get_path(nav_map, origin, point, true)
	
	if path.size() < 2: return origin
	
	return point

func _move():
	enemy.navigation_agent.target_desired_distance = 0.5
	enemy.speed = enemy.stats.move_speed * 2.0
	var ret_val = enemy.move_towards_target()
	enemy.navigation_agent.target_desired_distance = original_target_desired_distance
	
	return ret_val
	
func _get_default_neighbours():
	var min_distance = enemy.stats.min_distance_from_target
	var neighbours = Utils.get_in_range_from_group(enemy, &"enemy", min_distance)
	
	if enemy.get_player_distance() < enemy.stats.min_distance_from_target:
		neighbours.append(enemy.player)
	
	return neighbours
	
func _build_neighbours(others_in_proximity: Array):
	var neighbours: Array[Vector3] = []
	
	for n in others_in_proximity:
		neighbours.append(n.global_position)
	
	return neighbours
