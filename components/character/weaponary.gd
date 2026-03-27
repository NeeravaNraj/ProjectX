extends Node3D

@onready var player = $".."

const ATTACK_COST = 5
var weapon: Weapon

func _ready() -> void:
	weapon = get_child(0) as Weapon
	assert(weapon, "Expected weapon to exist [%s]" % [str(get_path())])
	weapon.attack.connect(_on_attack)

func _physics_process(_delta: float) -> void:
	global_position = player.get_global_transform_interpolated().origin
	weapon.attack_damage_multiplier = player.stat_energy.value

func _on_attack():
	player.stat_energy.value -= ATTACK_COST
	_build_momentum()

func _build_momentum():
	player.stat_momentum.growth_rate = player.player_stats.attack_momentum_growth_factor
	player.stat_momentum.allow_growth = true
	await get_tree().create_timer(1).timeout
	player.stat_momentum.allow_growth = false
