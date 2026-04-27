@tool
class_name Line3D extends Node3D

@export var material: Material
@export var thickness = 0.5
@export var segments = 8
@export var origin: Vector3 = Vector3.ZERO
@export var endpoint: Vector3 = Vector3.UP

@onready var line_mesh: MeshInstance3D = $LineMesh

var top = []
var bottom = []
var length = 1.0
var direction: Vector3

func _physics_process(_delta: float) -> void:
	get_end_cap_vertices()
	draw_sides()
	draw_ends()
	apply_materials()

func get_end_cap_vertices():
	top.clear()
	bottom.clear()
	
	if not origin:
		origin = position
	var target = origin - endpoint
	
	direction = target.normalized()
	length = target.length()
	
	var tangent = direction.cross(Vector3.UP)
	if tangent.length() == 0:
		tangent = direction.cross(Vector3.RIGHT)

	tangent = tangent.normalized()
	var bitangent = direction.cross(tangent).normalized()
	
	for i in range(segments + 1):
		var angle = TAU * i / segments
		var circle_offset = cos(angle) * tangent * thickness + sin(angle) * bitangent * thickness
		
		top.append(endpoint + circle_offset)
		bottom.append(origin + circle_offset)

func draw_sides():
	var mesh = line_mesh.mesh as ImmediateMesh
	
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	for i in range(segments + 1):
		var top_v = top[i]
		var bot_v = bottom[i]
		var normal = (top[i] - endpoint).normalized()
		
		mesh.surface_set_normal(normal)
		mesh.surface_add_vertex(top_v)
		
		mesh.surface_set_normal(normal)
		mesh.surface_add_vertex(bot_v)
	mesh.surface_end()

func draw_ends():
	draw_end_cap(top, 1)
	draw_end_cap(bottom, -1)

func draw_end_cap(points: Array, _sign = 1):
	var mesh = line_mesh.mesh as ImmediateMesh
	var _range = range(segments)
	var center = endpoint
	
	if _sign != 1:
		_range = range(segments, -1, -1)
		center = origin
	
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in _range:
		var a = points[i]
		var b = points[i + 1 * _sign]
		mesh.surface_set_normal(_sign * direction)
		mesh.surface_add_vertex(center)
		
		mesh.surface_set_normal(_sign * direction)
		mesh.surface_add_vertex(a)
		
		mesh.surface_set_normal(_sign * direction)
		mesh.surface_add_vertex(b)
	mesh.surface_end()

func apply_materials():
	if not material: return
	var mesh = line_mesh.mesh as ImmediateMesh
	mesh.surface_set_material(0, material)
	mesh.surface_set_material(1, material)
	mesh.surface_set_material(2, material)
