class_name ZoningGrenade extends Node3D

@onready var hit_timer: Timer = $HitTimer
@onready var despawn_timer: Timer = $DespawnTimer
@onready var rigid_body: RigidBody3D = $RigidBody3D
@onready var visual_body: MeshInstance3D = $RigidBody3D/VisualBody
@onready var explosion_mesh: MeshInstance3D = $RigidBody3D/Explosion
@onready var explosion_area: HitBox = $RigidBody3D/ExplosionArea
@onready var explosion_collision_shape: CollisionShape3D = $RigidBody3D/ExplosionArea/CollisionShape3D

var packet: DamagePacket = DamagePacket.new(25.0)

#func _init(p_packet: DamagePacket) -> void:
	#packet = p_packet

func _ready() -> void:
	rigid_body.get_colliding_bodies()
	set_physics_process(false)

func _on_rigid_body_3d_body_entered(_body: Node) -> void:
	rigid_body.freeze = true
	visual_body.visible = false
	explosion_mesh.visible = true
	explosion_area.monitoring = true
	rigid_body.collision_layer = 0
	
	despawn_timer.start()
	set_physics_process(true)
	
	var tween = create_tween()
	tween.tween_method(_grow_blast_area, 0.5, 5.0, 0.2)

func _grow_blast_area(radius: float):
	var visual_shape = explosion_mesh.mesh as SphereMesh
	var collision_shape = explosion_collision_shape.shape as SphereShape3D
	
	visual_shape.radius = radius
	collision_shape.radius = radius
	visual_shape.height = radius * 2


func _on_despawn_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_method(_grow_blast_area, 5.0, 0.0, 0.5)
	await tween.finished
	queue_free()

func _physics_process(delta: float) -> void:
	if hit_timer.is_stopped():
		hit_timer.start()
		explosion_area.attack(packet)

func _on_explosion_area_area_entered(area: Area3D) -> void:
	print(area)
