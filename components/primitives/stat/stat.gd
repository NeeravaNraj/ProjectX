class_name Stat extends Node

@export var value: float = 0.0
@export var max_value: float = 0.0
@export var min_value: float = 0.0

@export var auto_grow: bool = false
@export var growth_tick_delay: float = 0.1
@export var growth_rate: float = 1.0
@export var growth_rate_modifier: float = 0.0

@onready var growth_timer: Timer = $GrowthDelay

signal stat_value_changed(delta: float)
signal reached_max(value: float)
signal reached_min(value: float)

var _process_mode = Node.PROCESS_MODE_INHERIT

func update_value(delta: float):
	var previous = value
	value = clampf(value + delta, min_value, max_value)
	stat_value_changed.emit(value - previous)
	
	if value == max_value:
		reached_max.emit(value)
	
	if value == min_value:
		reached_min.emit(value)

func _ready() -> void:
	_process_mode = Node.PROCESS_MODE_INHERIT if auto_grow else Node.PROCESS_MODE_DISABLED
	growth_timer.wait_time = growth_tick_delay
	growth_timer.timeout.connect(_on_growth)

func _process(_delta: float) -> void:
	if growth_timer.is_stopped():
		growth_timer.start()
	
func _on_growth():
	update_value(growth_rate + growth_rate_modifier)
