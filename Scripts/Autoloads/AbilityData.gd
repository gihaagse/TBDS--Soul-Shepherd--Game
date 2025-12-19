extends Node

enum platforms{
	kbm,
	controller
}
var current_platform: platforms = platforms.kbm

@onready var unlocked_abilities: Array = []

#Recomment this for the real game to only unlock default abilities
@onready var default_abilities: Array = [
	ability_list.Idling, 
	ability_list.Walking, 
	ability_list.Falling, 
	ability_list.Attack1,
	ability_list.Airattack1, 
	ability_list.Archery,
	ability_list.Dialogue
]

#@onready var default_abilities: Array = ability_list.values()

signal update_debug_ability_label
signal update_unlock_ability_buttons
signal update_delete_ability_buttons
signal cooldown_started
signal abilities_updated

enum ability_list {
	Idling,
	Walking,
	Falling,
	Dialogue,
	
	Attack1,
	Airattack1,
	Archery,
	
	Dash,
	Wallsliding,
	DoubleJump,
	WallJump,
	Airgliding,

}

var cooldowns: Dictionary = {
	ability_list.Dash: 1.0,
	ability_list.Attack1: 0.5,
	ability_list.Archery: 0.5,
	ability_list.WallJump: 0.2
}

var active_cooldown_timers = {}

const ABILITY_ACTION: Dictionary = {
	ability_list.Attack1: "LeftClick",
	ability_list.Archery: "RightClick",
	ability_list.Dash: "Shift",
	ability_list.DoubleJump: "Jump",
	ability_list.WallJump: "Jump",
	ability_list.Airgliding: "Jump",
	ability_list.Wallsliding: ""

}

const INFO: Dictionary = {
	ability_list.Attack1:{
		"name": "Swing Attack",
		"description": "Press '%s' to perform a SWING ATTACK!" 
	},
	ability_list.Archery: {
		"name": "Bamboo Hat Throw",
		"description": "Press '%s' to throw your hat for a RANGED ATTACK!"
	},
	ability_list.Dash: {
		"name": "Dash",
		"description": "Press '%s' to Dash forwards!"
	},
	ability_list.DoubleJump:{
		"name": "Double Jump",
		"description": "Press '%s' again in the air to Double Jump! 
		\nLand on the ground to refresh the Double Jump"
	},
	ability_list.WallJump: {
		"name": "Wall Jump",
		"description": "Press 'Jump' while going into a wall to Wall Jump!"
	},
	ability_list.Wallsliding: {
		"name": "Wall Slide",
		"description": "Move into a wall while falling to slow down and Wall Slide!"
	},
	ability_list.Airgliding: {
		"name": "Air Gliding",
		"description": "Hold '%s' in the air to glide down!"
		
	},
}


func _ready() -> void:
	load_default_abilities()
	OptionsManager.input_scheme_changed.connect(_on_input_scheme_changed)

	#pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func load_default_abilities() -> void:
	for ability in ability_list:
		ability = get_value_from_ability_name(ability)
		if ability in default_abilities:
			unlocked_abilities.append(ability)

func get_ability_name_from_value(value: int) -> String:
	for key in AbilityData.ability_list.keys():
		if AbilityData.ability_list[key] == value:
			return key
	return "Unknown"

func get_value_from_ability_name(ability_name: String) -> int:
	var ability_name_lower = ability_name.to_lower()
	for enum_name in AbilityData.ability_list.keys():
		if enum_name.to_lower() == ability_name_lower:
			return AbilityData.ability_list[enum_name]
	return -1
	
func add_collected_ability_add_to_list(ability: ability_list) -> void:
	if ability not in unlocked_abilities:
		unlocked_abilities.append(ability)
		update_debug_ability_label.emit()
		update_delete_ability_buttons.emit()
		update_unlock_ability_buttons.emit()
		abilities_updated.emit()
		
func start_cooldown(ability: int) -> void:
	if ability not in unlocked_abilities:
		push_warning("Ability niet unlocked: %s" % ability)
		return
	var duration = cooldowns.get(ability, 0)
	if duration > 0:
		active_cooldown_timers[ability] = duration
		emit_signal("cooldown_started", ability)
		
func process_cooldowns(delta: float) -> void:
	var to_be_removed = []
	
	for ability in active_cooldown_timers.keys():
		active_cooldown_timers[ability] -= delta
		if active_cooldown_timers[ability] <= 0:
			to_be_removed.append(ability)
			
	for ability in to_be_removed:
		active_cooldown_timers.erase(ability)
		
func reset_abilities() -> void:
	unlocked_abilities = default_abilities.duplicate()

func _on_input_scheme_changed(scheme_name: String) -> void:
	if scheme_name == "kbm":
		current_platform = platforms.kbm
	else:
		current_platform = platforms.controller
		
func get_action_label(action_name: String) -> String:
	var events := InputMap.action_get_events(action_name)
	if events.is_empty():
		return "Unbound"

	var ev: InputEvent = null

	for e in events:
		if current_platform == platforms.kbm:
			if e is InputEventKey or e is InputEventMouseButton:
				ev = e
				break
		elif current_platform == platforms.controller:
			if e is InputEventJoypadButton or e is InputEventJoypadMotion:
				ev = e
				break

	if ev == null:
		return "Unbound"

	if ev is InputEventMouseButton:
		return "Mouse %d" % ev.button_index

	if ev is InputEventKey:
		return OS.get_keycode_string(ev.physical_keycode)

	if ev is InputEventJoypadButton:
		return OptionsManager.get_joypad_button_string(ev.button_index)

	if ev is InputEventJoypadMotion:
		return OptionsManager.get_joypad_motion_name(ev)

	return "Unknown"


func get_ability_description(ability_id) -> String:
	for i in range (4):
		if ability_id == i:
			return ""
	var data: Dictionary = INFO[ability_id]
	var action_name: String = ABILITY_ACTION[ability_id]
	
	if action_name == "" or not ("%s" in data["description"]):
		return data["description"]
	
	var bind_text := get_action_label(action_name)
	return data["description"] % bind_text
