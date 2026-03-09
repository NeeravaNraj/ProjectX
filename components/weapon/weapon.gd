class_name Weapon extends Node

@export_category("Weapon stats")
@export var attack_damage: int = 10
@export var attack_speed: float = 0.05

@export var attack_area: Area3D
@export var element_selector: ElementSelector
@export var attack_area_shape: CollisionShape3D

signal attack()

var _can_attack := true

# TODO: temporary
func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	if event.is_action_pressed("left_click"):
		_attack()

func _attack():
	if not _can_attack: return
	
	for body in attack_area.get_overlapping_bodies():
		var hurtbox = body.get("hurtbox") as HurtBox
		
		var packet = DamagePacket.new(
			attack_damage,
			element_selector.current_element
		)
		
		if hurtbox:
			hurtbox.damage(packet)
			
	attack.emit()
	animate_attack()
	start_timer()
	
func start_timer():
	_can_attack = false
	await get_tree().create_timer(attack_speed).timeout
	_can_attack = true

func animate_attack(): pass
