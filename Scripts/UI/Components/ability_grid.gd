extends Control

@export var cooldown_indicator_scene: PackedScene = preload("res://Scenes/UI/Components/ability_icon_timers.tscn")
@export var icons_path: String = "res://assets/icons/abilities"
@onready var grid_container: GridContainer = $GridContainer

var ability_icons = {}
var active_indicators = {} 

func _ready():
	ability_icons = load_ability_icons(icons_path)
	AbilityData.connect("abilities_updated", Callable(self, "_update_ui"))
	AbilityData.connect("cooldown_started", Callable(self, "_on_cooldown_start"))

func _process(delta: float) -> void:
	AbilityData.process_cooldowns(delta)
	for ability in active_indicators.keys():
		var fraction = 0
		if ability in AbilityData.active_cooldown_timers:
			var timer = AbilityData.active_cooldown_timers[ability]
			var max_cd = AbilityData.cooldowns.get(ability, 1)
			fraction = timer / max_cd if max_cd > 0 else 0
		active_indicators[ability].set_cooldown_fraction(fraction)
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
		if ability not in AbilityData.active_cooldown_timers.keys():
			active_indicators[ability].queue_free()
			active_indicators.erase(ability)

	for ability in AbilityData.active_cooldown_timers.keys():
		if ability not in active_indicators:
			var icon = ability_icons.get(ability, null)
			if icon:
				var indicator = cooldown_indicator_scene.instantiate()
				grid_container.add_child(indicator)
				indicator.set_icon(icon)
				active_indicators[ability] = indicator
				indicator.set_cooldown_fraction(0)
			else:
				pass
func _on_cooldown_start(ability):
	if ability in active_indicators:
		active_indicators[ability].set_cooldown_fraction(1)
