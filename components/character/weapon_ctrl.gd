extends Node3D

const ATTACK_COST = 5
const StatIdent = StatsComponent.StatIdent

@onready var player = $".."
@onready var stats: StatsComponent = %StatsComponent
@onready var camera_pivot: Node3D = $"../CameraPivot"
@onready var fp_rig: PlayerFirstPersonRig = $"../CameraPivot/Camera/FirstPersonRig"


@export var weapon: WeaponDefinition

var attack_direction = Vector3.ZERO
var hurtbox_mask: int = Utils.get_collition_layer_by_name("HurtBox")

var _can_attack := true
var _energy_damage_multiplier: StatModifier

func _ready() -> void:
	_energy_damage_multiplier = StatModifier.mult_percent(self, StatIdent.AttackDamage, -1)
	_equip_weapon()

func swap_weapon(p_weapon: WeaponDefinition):
	weapon = p_weapon
	_equip_weapon()
	
func attack():
	if not _can_attack: return
	
	var damage = stats.get_computed_stat(StatIdent.AttackDamage)
	var packet = DamagePacket.new(damage, 0.0, -player.get_forward())
	
	var center = Vector3(0.0, weapon.vertical_offset, -(weapon.near_offset + weapon.melee_range.z * 0.5))
	var query_transform := camera_pivot.global_transform.translated_local(center)
	
	var targets: Array[HurtBox] = HitQuery3D.query_box(player.space_state, query_transform, weapon.melee_range, hurtbox_mask)
	
	for target in targets:
		target.damage(packet)
		_on_hit(target, packet)

	_start_timer()

func _physics_process(_delta: float) -> void:
	global_position = player.get_global_transform_interpolated().origin
	_energy_damage_multiplier.value = player.stat_energy.value - 1

func _equip_weapon():
	if weapon == null: return
	var mods = [
		_energy_damage_multiplier,
		StatModifier.flat(self, StatIdent.AttackDamage, weapon.attack_damage),
		StatModifier.flat(self, StatIdent.AttackSpeed, weapon.attack_speed)
	] as Array[StatModifier]
	stats.add_modifiers(mods)

	var weapon_view = weapon.view_scene.instantiate()
	fp_rig.attach_weapon(weapon_view)

func _on_hit(_hurtbox: HurtBox, _packet: DamagePacket):
	player.stat_energy.update_value(-ATTACK_COST)
	_build_momentum()

func _build_momentum():
	var attack_momentum_growth_factor = stats.get_computed_stat(player.stat_ident.AttackMomentumGrowthFactor)
	player.stat_momentum.growth_rate = attack_momentum_growth_factor
	player.stat_momentum.allow_growth = true
	await get_tree().create_timer(1).timeout
	player.stat_momentum.allow_growth = false

func _start_timer():
	var attack_speed = stats.get_computed_stat(player.stat_ident.AttackSpeed)
	_can_attack = false
	await get_tree().create_timer(attack_speed).timeout
	_can_attack = true
