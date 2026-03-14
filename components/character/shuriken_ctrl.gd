class_name ShurikenCtrl extends Node3D

@onready var player = $".."
@onready var shuriken_timer = $ShurikenTimer
@onready var shuriken_spawn = $ShurikenSpawnPoint

const MAX_DISTANCE := 25

var shuriken_scene = preload("res://components/shuriken/shuriken.tscn")
var grapple_location = null
var current_shuriken = null

func get_grapple_location():
	if !grapple_location: return null
	var grapple_position = _get_height_adjusted_location()
	
	var direction = (grapple_position - player.global_position).normalized()
	var distance = (grapple_location - player.global_position).length()
	
	if distance > MAX_DISTANCE: return null
	
	return [direction, distance]

func throw_shuriken():
	if not shuriken_timer.is_stopped(): return
	
	var direction = player.get_forward()
	
	var shuriken: Shuriken = shuriken_scene.instantiate()
	add_child(shuriken)
	current_shuriken = shuriken
	
	if not shuriken.shuriken_hit.is_connected(_on_shuriken_hit):
		shuriken.shuriken_hit.connect(_on_shuriken_hit)
	
	shuriken.visible = true
	shuriken.top_level = true
	shuriken.transform.origin = shuriken_spawn.global_position
	
	shuriken.throw(direction)
	shuriken_timer.start()

func pickup_shuriken(shuriken: Shuriken):
	grapple_location = null
	if not shuriken: return
	shuriken_timer.stop()
	shuriken.queue_free()

func _physics_process(_delta: float) -> void:
	if not current_shuriken: return
	var distance = _get_distance()
	current_shuriken.illuminate(0 if distance < MAX_DISTANCE else 100)
	

func _get_distance():
	if not grapple_location: return 100
	return (grapple_location - player.global_position).length()

func _get_height_adjusted_location():
	var grapple_position = Vector3(grapple_location)
	grapple_position.y += player.get_height() * 1.5
	
	return grapple_position

func _on_shuriken_hit(location: Vector3):
	grapple_location = location
