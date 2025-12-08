extends Control
@export var cooldown_indicator_scene: PackedScene = preload("res://Scenes/UI/Components/ability_icon_timers.tscn")
@export var icons_path: String = "res://assets/icons/abilities"
@onready var grid_container: GridContainer = $MarginContainer/VBoxContainer/CenterContainer/GridContainer

var ability_icons = {}
var active_indicators = {} 


func _ready():
	ability_icons = load_ability_icons(icons_path)
	AbilityData.connect("abilities_updated", Callable(self, "_update_ui"))
	$MarginContainer/VBoxContainer/CenterContainer/GridContainer.grab_focus()
	
func _process(_delta: float) -> void:
	
	_update_ui()
	
func load_ability_icons(path: String) -> Dictionary:
	var icons = {}
	var dir = DirAccess.open(path)
	if not dir:
		push_error("Map niet gevonden: %s" % path)
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
			else:
				pass
	OptionsManager._set_focus_all_on_children(self)
	
