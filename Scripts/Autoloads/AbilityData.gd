extends Node

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
	Attack1,
	Airattack1,
	Archery,
	Dialogue,
	
	Dash,
	Wallsliding,
	DoubleJump,
	WallJump,
	Airgliding,
	Grapple,

}

var cooldowns: Dictionary = {
	ability_list.Dash: 1.0,
	ability_list.Attack1: 0.5,
	ability_list.Archery: 0.5,
	ability_list.WallJump: 0.2
}

var active_cooldown_timers = {}

const INFO: Dictionary = {
	ability_list.Attack1:{
		"name": "Swing Attack",
		"description": "Press Left Mouse Button to perform a SWING ATTACK!"
	},
	ability_list.Archery: {
		"name": "Bamboo Hat Throw",
		"description": "Press Right Mouse Button to throw your hat for a RANGED ATTACK!"
	},
	ability_list.Dash: {
		"name": "Dash",
		"description": "Press 'Shift' to Dash forwards!"
	},
	ability_list.DoubleJump:{
		"name": "Double Jump",
		"description": "Press 'Jump' again in the air to Double Jump! 
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
		"description": "Hold 'Space' in the air to glide down!"
		
	},
	ability_list.Grapple: {
		"name": "Grappling Hook",
		"description": "Press 'Scrollwheel' button on a platform to grapple!"
	}
}


func _ready() -> void:
	load_default_abilities()
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
