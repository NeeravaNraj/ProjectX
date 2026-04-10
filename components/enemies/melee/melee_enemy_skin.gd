class_name MeleeEnemySkin extends Node3D

@export var parent_hurtbox: HurtBox

@onready var anim_tree = $AnimationTree
@onready var hitbox: HitBox = $Armature/Skeleton3D/BoneAttachment3D/MeshInstance3D/HitBox
@onready var anim_playback: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")

enum MovementStates {
	Idle = 0,
	Running = 1,
}

signal attack_finished()
signal search_finished()

var packet = null

func _ready():
	assert(parent_hurtbox, "parent_hurtbox should be defined in [%s]" % [str(get_path())])
	anim_tree.animation_finished.connect(_on_state_finished)
	hitbox.exclude.append(parent_hurtbox)
	
func attack(p_packet: DamagePacket):
	packet = p_packet
	anim_playback.travel(&"Attack")

func searching():
	anim_playback.travel(&"Searching")

func die():
	anim_playback.travel(&"Dying")
	
func locomotion(state: MovementStates):
	var tween = create_tween()
	tween.tween_property(anim_tree, "parameters/Locomotion/blend_position", float(state), 0.3)

func stagger():
	var value = randi_range(0, 1)
	anim_tree.set("parameters/Stagger/Blend2/blend_amount", value)
	anim_playback.travel(&"Stagger")

func _on_state_finished(name: StringName):
	match name:
		&"Attack":
			attack_finished.emit()
		&"Searching":
			search_finished.emit()


func _on_hit_box_area_entered(area: Area3D) -> void:
	if packet == null: return
	hitbox.attack(packet)
