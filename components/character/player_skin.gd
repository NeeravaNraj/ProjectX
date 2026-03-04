class_name PlayerSkin extends Node3D

@export var player: Player
@export var weapon: Weapon


@onready var animationtree: AnimationTree = $AnimationTree
@onready var skeleton: Skeleton3D = $Armature/Skeleton3D

const HEAD_BONE := 5

func _ready() -> void:
	$Armature/Skeleton3D/RightHandAttachment.add_child(weapon)

func _physics_process(_delta: float) -> void:
	var speed = player.velocity.normalized().length()
	animationtree.set("parameters/MovementBlendSpace/blend_position", speed)

func attack():
	animationtree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
func jump():
	animationtree.set("parameters/JumpOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func get_head() -> Transform3D:
	return $Armature/Skeleton3D.get_bone_global_pose(5)

func toggle_head_hide(show: bool):
	skeleton.set_bone_pose_scale(HEAD_BONE, Vector3.ONE * (show as float))
