class_name DebugTracker
extends PanelContainer

const GLOBAL_GROUP := "__global__"

@onready var root_container: VBoxContainer = $VBoxContainer

var groups := {}   # group_name -> VBoxContainer
var items := {}    # "group/key" -> Label (value label)
var values := {}

func _ready():
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0.6) # semi-transparent black
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_left = 6
	style.corner_radius_bottom_right = 6
	style.content_margin_top = 4
	style.content_margin_bottom = 4
	style.content_margin_left = 10
	style.content_margin_right = 10

	add_theme_stylebox_override("panel", style)

	root_container.add_theme_constant_override("separation", 4)

func _process(_delta):
	for path in values:
		var label = items.get(path)
		if label:
			label.text = _format(values[path])

# -------------------------
# Public API
# -------------------------

func track(key: String, value):
	_track_internal(GLOBAL_GROUP, key, value)

func untrack(key: String):
	_untrack_internal(GLOBAL_GROUP, key)

func track_in_group(group: String, key: String, value):
	_track_internal(group, key, value)

func untrack_from_group(group: String, key: String):
	_untrack_internal(group, key)

# -------------------------
# Internal
# -------------------------

func _track_internal(group: String, key: String, value):
	var path = _make_path(group, key)
	values[path] = value

	var container = _get_or_create_group(group)

	if not items.has(path):
		var panel = PanelContainer.new()
		var style = StyleBoxFlat.new()
		
		style.bg_color = Color(0.285, 0.285, 0.285, 0.5)
		style.content_margin_top = 4
		style.content_margin_bottom = 4
		style.content_margin_left = 10
		style.content_margin_right = 10
		style.corner_radius_top_left = 6
		style.corner_radius_top_right = 6
		style.corner_radius_bottom_left = 6
		style.corner_radius_bottom_right = 6
		panel.add_theme_stylebox_override("panel", style)

		var row = HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.custom_minimum_size.y = 20
		row.add_theme_constant_override("separation", 10)

		var key_label = Label.new()
		key_label.text = key
		key_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var value_label = Label.new()
		value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

		row.add_child(key_label)
		row.add_child(value_label)

		panel.add_child(row)
		container.add_child(panel)

		items[path] = value_label

func _untrack_internal(group: String, key: String):
	var path = _make_path(group, key)

	values.erase(path)

	if items.has(path):
		var value_label = items[path]
		var row = value_label.get_parent()
		row.queue_free()
		items.erase(path)

	_cleanup_group_if_empty(group)

# -------------------------
# Helpers
# -------------------------

func _get_or_create_group(group: String) -> VBoxContainer:
	if groups.has(group):
		return groups[group]

	var container: VBoxContainer

	if group == GLOBAL_GROUP:
		container = root_container
	else:
		# Group title
		var title = Label.new()
		title.text = group
		title.add_theme_font_size_override("font_size", 14)

		container = VBoxContainer.new()

		root_container.add_child(title)
		root_container.add_child(container)

	groups[group] = container
	return container

func _cleanup_group_if_empty(group: String):
	if group == GLOBAL_GROUP:
		return

	var container = groups.get(group)
	if container and container.get_child_count() == 0:
		var title = container.get_previous_sibling()
		if title:
			title.queue_free()
		container.queue_free()
		groups.erase(group)

func _make_path(group: String, key: String) -> String:
	return "%s/%s" % [group, key]

func _format(v):
	if typeof(v) == TYPE_FLOAT:
		return "%.2f" % v
	return str(v)
