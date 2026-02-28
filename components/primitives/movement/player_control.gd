class_name PlayerControl extends BaseControl

## The input action to move up.
@export var input_action_up: InputEventAction

## The input action to move down.
@export var input_action_down: InputEventAction
	
## The input action to move left.
@export var input_action_left: InputEventAction

## The input action to move right.
@export var input_action_right: InputEventAction

## The input action to move right.
@export var input_action_sprint: InputEventAction

func _ready() -> void:
	super()
	
	if null == input_action_up:
		reset_action_up()

	if null == input_action_down:
		reset_action_down()
	
	if null == input_action_left:
		reset_action_left()

	if null == input_action_right:
		reset_action_right()
		
	if null == input_action_sprint:
		reset_action_sprint()

func _process(_delta: float) -> void:
	velocity_component.raw_direction = Input.get_vector(
		input_action_left.action,
		input_action_right.action,
		input_action_up.action,
		input_action_down.action,
	)

func reset_action_up() -> void:
	input_action_up = InputEventAction.new()
	input_action_up.action = DEFAULT_ACTION_UP

func reset_action_down() -> void:
	input_action_down = InputEventAction.new()
	input_action_down.action = DEFAULT_ACTION_DOWN

func reset_action_left() -> void:
	input_action_left = InputEventAction.new()
	input_action_left.action = DEFAULT_ACTION_LEFT

func reset_action_right() -> void:
	input_action_right = InputEventAction.new()
	input_action_right.action = DEFAULT_ACTION_RIGHT
	
func reset_action_sprint() -> void:
	input_action_sprint = InputEventAction.new()
	input_action_sprint.action = DEFAULT_ACTION_SPRINT
