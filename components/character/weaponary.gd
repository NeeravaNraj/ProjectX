extends Node3D

@export var hitbox: HitBox
@onready var player = $".."

const ATTACK_COST = 5

var weapon: Weapon
var attack_direction = Vector3.ZERO

var _can_attack := true

func _ready() -> void:
	weapon = get_child(0) as Weapon
	assert(weapon, "Expected weapon to exist [%s]" % [str(get_path())])
	hitbox.hit.connect(_on_hit)

func _physics_process(_delta: float) -> void:
	global_position = player.get_global_transform_interpolated().origin
	weapon.attack_damage_multiplier = player.stat_energy.value

func _on_hit(_hurtbox: HurtBox, _packet: DamagePacket):
	player.stat_energy.update_value(-ATTACK_COST)
	_build_momentum()

func _build_momentum():
	player.stat_momentum.growth_rate = player.player_stats.attack_momentum_growth_factor
	player.stat_momentum.allow_growth = true
	await get_tree().create_timer(1).timeout
	player.stat_momentum.allow_growth = false

func attack():
	if not _can_attack: return
	
	var packet = DamagePacket.new(
			weapon.attack_damage,
			weapon.attack_damage_modifier,
			weapon.attack_damage_multiplier,
			-player.get_forward(),
	)
	hitbox.attack(packet)
	start_timer()

func start_timer():
	_can_attack = false
	await get_tree().create_timer(weapon.attack_speed + weapon.attack_speed_modifier).timeout
	_can_attack = true
