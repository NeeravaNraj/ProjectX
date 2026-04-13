class_name MeleeEnemy extends BaseEnemy

@onready var enemy_skin = $MeleeEnemySkin
@onready var bt_player: BTPlayer = $BTPlayer
@onready var hurtbox: HurtBox = $Areas/HurtBox
@onready var _velocity: VelocityComponent = $VelocityComponent
@onready var hit_box: HitBox = $MeleeEnemySkin/Armature/Skeleton3D/BoneAttachment3D/MeshInstance3D/HitBox

var can_attack = true
var hit_direction = Vector3.ZERO

func _ready() -> void:
	init()

func lookat(dir: Vector3):
	dir.y = 0
	look_at(global_position + dir, Vector3.UP)

func lookat_player():
	if not player: return
	lookat(player.global_position - global_position)

func attack():
	velocity_component.set_velocity(Vector3.ZERO)
	can_attack = true

func running():
	speed = stats.move_speed
	lookat(get_movement_direction())
	return move_towards_target()

func _on_hurt_box_hit(packet: DamagePacket) -> void:
	hit_direction = packet.attack_direction * packet.knockback_modifier
	hit_direction.y += 0.5 * packet.knockback_modifier
	enemy_skin.stagger()

func _on_hit_box_area_entered(_area: Area3D) -> void:
	if not can_attack: return
	hit_box.attack(packet)
	can_attack = false

func _on_health_death() -> void:
	queue_free()
