class_name Enemy extends CharacterBody3D

@export var enemy_stats: EnemyStats

@onready var hurtbox: HurtBox = $HurtBox
@onready var state_chart: StateChart = %StateChart
@onready var detection_area: Area3D = $DetectionArea
@onready var detection_shape: CollisionShape3D = $DetectionArea/CollisionShape3D
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
# @onready var _velocity: VelocityComponent = $Velocity

var starting_position: Vector3
var speed: float

var player: Variant = null
var last_player_position = null

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
	
	velocity = direction * speed
	move_and_slide()

#func _physics_process(delta: float) -> void:
	#if not player or navigation_agent.is_navigation_finished(): return
	#var current_agent_position: Vector3 = global_position
	#var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	#var direction = current_agent_position.direction_to(next_path_position)
	#
	#velocity = direction * speed
	#move_and_slide()

func _on_health_damaged(amount: int) -> void:
	print("Enemy DAMANGED ", amount)


func _on_health_death() -> void:
	print("Enemy DIEDED!")
