extends Control

@export var cooldown_indicator_scene: PackedScene = preload("res://Scenes/UI/Components/ability_icon_timers.tscn")
@export var icons_path: String = "res://assets/icons/abilities"
@onready var grid_container: GridContainer = $MarginContainer/VBoxContainer/CenterContainer/GridContainer

var ability_icons = {}
var active_indicators = {}

var set_focus: bool = false

func _ready() -> void:
	ability_icons = load_ability_icons(icons_path)
	AbilityData.connect("abilities_updated", Callable(self, "_update_ui"))

func _process(delta: float) -> void:
	if not set_focus:
		_update_ui()
		set_focus_on_first()
		set_focus = true


func load_ability_icons(path: String) -> Dictionary:
	var icons = {}
	var dir = DirAccess.open(path)
	if not dir:
		push_error("Map not found: %s" % path)
		return icons
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			if file_name.to_lower().ends_with(".png") or file_name.to_lower().ends_with(".jpg"):
				var ability_name = file_name.get_basename()
				var ability_value = AbilityData.get_value_from_ability_name(ability_name)
				var texture_path = path + "/" + file_name
				icons[ability_value] = load(texture_path)
		file_name = dir.get_next()
	dir.list_dir_end()
	return icons

func _update_ui() -> void:
	for ability in active_indicators.keys():
		if ability not in AbilityData.unlocked_abilities:
			active_indicators[ability].queue_free()
			active_indicators.erase(ability)

	for ability in AbilityData.unlocked_abilities:
		if ability not in active_indicators:
			var icon = ability_icons.get(ability, null)
			if icon:
				var indicator = cooldown_indicator_scene.instantiate()
				grid_container.add_child(indicator)
				indicator.set_icon(icon)
				active_indicators[ability] = indicator
				indicator.set_cooldown_fraction(0)
				indicator.set_default_info_label_text(ability)
				indicator.set_minimum_size()
	_update_indicator_focus_neighbors()

func refresh_all_indicators() -> void:
	for indicator in active_indicators.values():
		if is_instance_valid(indicator):
			indicator.refresh_description()

func _update_indicator_focus_neighbors() -> void:
	var count := grid_container.get_child_count()
	if count == 0:
		return

	for i in range(count):
		var indicator := grid_container.get_child(i)
		if not indicator is Control:
			continue

		var icon_btn := indicator.get_node("HBoxContainer/AbilityIconButton") as BaseButton
		var label_btn := indicator.get_node("HBoxContainer/IconButtonResizer/LabelButton") as BaseButton

		if icon_btn:
			icon_btn.focus_mode = Control.FOCUS_ALL
		if label_btn:
			label_btn.focus_mode = Control.FOCUS_ALL

		var up_indicator : Control = null
		var down_indicator : Control = null

		if i > 0:
			up_indicator = grid_container.get_child(i - 1)
		if i < count - 1:
			down_indicator = grid_container.get_child(i + 1)

		if icon_btn:
			if up_indicator:
				var up_icon := up_indicator.get_node("HBoxContainer/AbilityIconButton") as BaseButton
				if up_icon:
					icon_btn.focus_neighbor_top = up_icon.get_path()
			if down_indicator:
				var down_icon := down_indicator.get_node("HBoxContainer/AbilityIconButton") as BaseButton
				if down_icon:
					icon_btn.focus_neighbor_bottom = down_icon.get_path()

		if label_btn:
			if up_indicator:
				var up_label := up_indicator.get_node("HBoxContainer/IconButtonResizer/LabelButton") as BaseButton
				if up_label:
					label_btn.focus_neighbor_top = up_label.get_path()
			if down_indicator:
				var down_label := down_indicator.get_node("HBoxContainer/IconButtonResizer/LabelButton") as BaseButton
				if down_label:
					label_btn.focus_neighbor_bottom = down_label.get_path()

func set_focus_on_first() -> void:
	var count := grid_container.get_child_count()
	if count == 0:
		return
	
	var first_indicator := grid_container.get_child(0)
	if not first_indicator is Control:
		return
	
	var btn := first_indicator.get_node("HBoxContainer/IconButtonResizer/LabelButton") as BaseButton
	if btn:
		btn.focus_mode = Control.FOCUS_ALL
		btn.call_deferred("grab_focus")
