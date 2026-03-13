class_name Shuriken extends Node3D

@onready var body = $ShurikenBody
@onready var grapple_sprite = $Sprite3D
@onready var despawn_timer = $DespawnTimer

var max_speed: float = 90
var rotation_speed: float = 20

var attached_to = null
var attached_location = Vector3.ZERO

var direction = Vector3.ZERO

signal shuriken_hit(location: Vector3)

func throw(p_direction: Vector3):
	direction = p_direction
	body.linear_velocity = -direction * max_speed
	body.angular_velocity = Vector3.FORWARD * rotation_speed

func illuminate(angle: float):
	var tween = create_tween()
	if angle < 25:
		tween.tween_property(grapple_sprite, "modulate", Color(0.2, 0.7, 0.7, 1.0), 0.3)
	else:
		tween.tween_property(grapple_sprite, "modulate", Color(1, 1, 1), 0.3)

func _physics_process(delta: float) -> void:
	if attached_to == null: return
	global_position = attached_to.to_global(attached_location)
	body.global_position = attached_to.to_global(attached_location)
	grapple_sprite.global_position = attached_to.to_global(attached_location)

func _stop():
	body.freeze = true
	body.linear_velocity = Vector3.ZERO
	body.angular_velocity = Vector3.ZERO
	body.add_to_group(&"pickup")
	despawn_timer.start()

func _on_body_entered(p_body: Node3D) -> void:
	_stop()
	if p_body.is_in_group(&"enemy"):
		attached_to = p_body
		attached_location = p_body.to_local(body.global_position)
	
		illuminate(0)
		grapple_sprite.global_position = body.global_position
		grapple_sprite.visible = true
		
		body.add_to_group(&"grapple_points")
		shuriken_hit.emit(p_body.global_position)
	

func _on_despawn_timer_timeout() -> void:
	queue_free()
