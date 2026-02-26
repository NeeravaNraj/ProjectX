class_name BaseControl extends Node

## The default input action for up movement.
const DEFAULT_ACTION_UP := &"move_up"

## The default input action for down movement.
const DEFAULT_ACTION_DOWN := &"move_down"

## The default input action for left movement.
const DEFAULT_ACTION_LEFT := &"move_left"

## The default input action for right movement.
const DEFAULT_ACTION_RIGHT := &"move_right"

var velocity_component: VelocityComponent

func _ready() -> void:
	velocity_component = get_parent() as VelocityComponent
	assert(velocity_component, "Expected BaseControl to be child of VelocityComponent - %s" % [str(get_path())])
