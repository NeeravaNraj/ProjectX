class_name ShurikenCtrl extends Node3D

@onready var player = $".."
@onready var shuriken_timer = $ShurikenTimer
@onready var shuriken_spawn = $ShurikenSpawnPoint

var shuriken_scene = preload("res://components/shuriken/shuriken.tscn")
var grapple_location = null

func get_grapple_location():
	if !grapple_location: return null
	var grapple_position = Vector3(grapple_location)
	grapple_position.y += player.get_height() * 1.5
	
	var direction = (grapple_position - player.global_position).normalized()
	var distance = (grapple_location - player.global_position).length()
	
	return [direction, distance]

func throw_shuriken():
	if not shuriken_timer.is_stopped(): return
	
	var direction = player.get_forward()
	
	var shuriken: Shuriken = shuriken_scene.instantiate()
	add_child(shuriken)
	
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

func _on_shuriken_hit(location: Vector3):
	grapple_location = location
