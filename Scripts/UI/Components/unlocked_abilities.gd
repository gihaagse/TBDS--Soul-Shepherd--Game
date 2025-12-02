extends Control


@onready var ability_label: Label = $VBoxContainer/abilityLabel
@onready var show_button: Button = $VBoxContainer/ShowButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AbilityData.connect("update_debug_ability_label", load_unlocked_abilities)
	ability_label.visible = false
	show_button.connect("pressed", on_toggle_pressed)
	load_unlocked_abilities()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func load_unlocked_abilities() -> void:
	if AbilityData.unlocked_abilities == null:
		return
		
	var lines: Array = []
	
	for ability in AbilityData.unlocked_abilities:
		if ability != null:
			var abName = AbilityData.get_ability_name_from_value(ability)
			lines.append(abName)
	ability_label.text = "\n".join(lines)

func on_toggle_pressed() -> void:
	$VBoxContainer/ShowButton.release_focus()
	ability_label.visible = not ability_label.visible
