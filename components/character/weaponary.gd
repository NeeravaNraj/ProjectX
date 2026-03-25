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
	weapon.attack_damage_modifier = player.stat_energy.value

func _on_attack():
	player.stat_energy.value -= ATTACK_COST
