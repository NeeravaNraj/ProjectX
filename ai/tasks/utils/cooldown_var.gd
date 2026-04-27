@tool
extends BTDecorator

@export var duration_var: StringName = &""
@export var default_value: float = 1.0

@export var process_pause: bool = false
@export var trigger_on_failure: bool = false

var timer: SceneTreeTimer
var duration: float
var _running: bool = false

func _enter() -> void:
	duration = blackboard.get_var(duration_var, default_value, false)
	if duration == null:
		push_warning("Could not find blackboard variable '%s' setting default value '%f'" % [duration_var, default_value])
	assert(typeof(duration) == TYPE_FLOAT)

func _tick(delta: float) -> Status:
	if get_child_count() == 0:
		push_error("CooldownVar has no child.")
		return FAILURE
	
	if _running: return FAILURE
		
	var status = get_child(0).execute(delta)
	if status == SUCCESS or (trigger_on_failure and status == FAILURE):
		_chill()
	return status

func _chill():
	_running = true
	if timer:
		timer.time_left = duration
	else:
		timer = agent.get_tree().create_timer(duration, process_pause)
		if not timer:
			push_error("Failed to create timer in CooldownVar")
		timer.timeout.connect(_on_timeout, CONNECT_ONE_SHOT)
		
func _on_timeout():
	timer = null
	_running = false

func _generate_name() -> String:
	var value = duration_var if duration_var != &"" else default_value
	return "Cooldown: '%s'" % [value]
