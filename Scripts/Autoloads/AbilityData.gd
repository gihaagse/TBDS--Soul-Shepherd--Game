extends Node

@onready var unlocked_abilities: Array = []
@onready var default_abilities: Array = [ability_list.Idling, ability_list.Walking, ability_list.Falling, ability_list.Attack1,ability_list.Airattack1, ability_list.Archery, ability_list.Dialogue]

signal update_debug_ability_label
signal update_unlock_ability_buttons
signal update_delete_ability_buttons

enum ability_list {
	Idling,
	Walking,
	Falling,
	Attack1,
	Airattack1,
	Dash,
	Archery,
	Wallsliding,
	DoubleJump,
	WallJump,
	Dialogue,
}

const INFO: Dictionary = {
	ability_list.Dash: {
		"name": "Dash",
		"description": "Press 'Shift' to Dash!"
	},
	ability_list.DoubleJump:{
		"name": "Double Jump",
		"description": "Press 'Jump' again in the air to Double Jump! \nLand on the ground to refresh the Double Jump"
	},
	ability_list.WallJump: {
		"name": "Wall Jump",
		"description": "Press 'Jump' while going into a wall to Wall Jump!"
	},
	ability_list.Wallsliding: {
		"name": "Wall Slide",
		"description": "Move into a wall while falling to slow down and Wall Slide!"
	},
}
# Called when the node enters the scene tree for the first time.



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
	
