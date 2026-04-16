class_name ZoningGrenade extends RigidBody3D

@onready var hit_timer: Timer = $HitTimer
@onready var despawn_timer: Timer = $DespawnTimer
@onready var bullet_hitbox: HitBox = $BulletHitbox
@onready var explosion_area: HitBox = $ExplosionArea
@onready var visual_body: MeshInstance3D = $VisualBody
@onready var explosion_fog: FogVolume = $ExplosionFog
@onready var explosion_mesh: MeshInstance3D = $Explosion
@onready var explosion_collision_shape: CollisionShape3D = $ExplosionArea/CollisionShape3D

var packet: DamagePacket:
	set(p):
		packet = p
		bullet_hitbox.default_packet = p

func _ready() -> void:
	set_physics_process(false)

func _on_body_entered(_body: Node) -> void:
	freeze = true
	collision_mask = 0
	visual_body.visible = false
	explosion_fog.visible = true
	explosion_mesh.visible = true
	explosion_area.monitoring = true
	
	despawn_timer.start()
	set_physics_process(true)
	
	var tween = create_tween()
	tween.tween_method(_grow_blast_area, 0.5, 5.0, 0.2)

func _grow_blast_area(radius: float):
	var visual_shape = explosion_mesh.mesh as SphereMesh
	var collision_shape = explosion_collision_shape.shape as SphereShape3D
	
	#var increased_radius = radius + 2.5
	var reduced_radius = radius
	collision_shape.radius = radius
	visual_shape.radius = radius
	visual_shape.height = radius * 2
	explosion_fog.size = Vector3.ONE * reduced_radius

func _on_despawn_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_method(_grow_blast_area, 5.0, 0.01, 0.5)
	await tween.finished
	queue_free()

func _physics_process(delta: float) -> void:
	if hit_timer.is_stopped():
		hit_timer.start()
		explosion_area.attack(packet)
