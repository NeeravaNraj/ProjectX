extends Node3D

@onready var entity_detector: Area3D = $EntityDetector
@onready var mesh: MeshInstance3D = $EntityDetector/Mesh

@export var jump_power: float = 20.0

func _on_entity_detector_body_entered(body: Node3D) -> void:
	var entity = body as CharacterBody3D
	if entity == null: return
	
	var velocity: VelocityComponent = entity.get("velocity_component")
	if velocity == null: return
	velocity.set_velocity(global_basis.y.normalized() * jump_power)
