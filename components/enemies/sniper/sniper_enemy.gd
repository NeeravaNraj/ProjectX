class_name SniperEnemy extends CharacterBody3D


@export var stats: SniperEnemyStats

@onready var hurtbox: HurtBox = $HurtBox
@onready var state_chart: StateChart = %StateChart
@onready var player_detection_area: Area3D = $PlayerDetectionArea
@onready var detection_shape: CollisionShape3D = $PlayerDetectionArea/PlayerDetectionShape

@onready var aim_pointer: Node3D = $AimPointer
@onready var laser_beam: LaserBeam = $AimPointer/LaserBeam


var starting_position: Vector3
var speed: float

var player: Variant = null
var last_player_position = null

signal alert(current_position: Vector3, player_position: Vector3)


func _ready() -> void:
	starting_position = self.global_position


func get_vistion_radius():
	var shape = detection_shape.shape as SphereShape3D
	return shape.radius

func get_player_distance():
	if not player: return INF
	var player_position = player.global_position
	return global_position.distance_to(player_position)


func _on_health_damaged(amount: int) -> void:
	print("Enemy DAMANGED ", amount)


func _on_health_death() -> void:
	self.queue_free()
