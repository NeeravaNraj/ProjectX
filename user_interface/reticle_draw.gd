extends Control

@export var radius: float = 0.1
@export var thickness: float = 1.0
@export var color: Color = Color.WHITE

@export var segments: int = 32


func _draw() -> void:
	draw_circle_crosshair()

func draw_circle_crosshair():
	var arc_segments = [
		[0, PI / 2],
		[PI / 2, PI],
		[PI, 3 * PI / 2],
		[3 * PI / 2, 2 * PI]
	]
	
	for arc in arc_segments:
		var start_angle = arc[0]
		var end_angle = arc[1]
		
		var points = []
		var step_size = (end_angle - start_angle) / segments
		
		for i in range(segments + 1):
			var angle = start_angle + i * step_size
			var point = Vector2(radius * cos(angle), radius * sin(angle))
			points.append(point)
		
		if points.size() > 1:
			draw_polyline(points, color, thickness, true)
