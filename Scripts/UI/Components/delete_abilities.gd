extends Control

@onready var ability_options: OptionButton = $VBoxContainer/AbilityOptions

var selected_ability

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_abilities_in_button()
	ability_options.item_selected.connect(ability_selected)
	AbilityData.update_delete_ability_buttons.connect(add_abilities_in_button)
	ability_selected(0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_abilities_in_button () -> void:
	if AbilityData.ability_list == null:
		print("is null")
		return
		
	ability_options.clear()
	
	for ability in AbilityData.ability_list:
		ability = AbilityData.get_value_from_ability_name(ability)
		
		if ability in AbilityData.unlocked_abilities:
			ability = AbilityData.get_ability_name_from_value(ability)
			ability_options.add_item(ability)
	
	if ability_options.get_item_count() > 0:
		ability_options.selected = 0
		ability_selected(0)

func ability_selected (index: int) -> void:
	var selected_text = ability_options.get_item_text(index)
	var selected_value: int = AbilityData.get_value_from_ability_name(selected_text)
	
	if selected_value != -1:
		selected_ability = selected_value
		
	else:
		print("Onbekende ability: ", selected_text)


func _on_button_pressed() -> void:
	$VBoxContainer/Button.release_focus()
	if AbilityData.unlocked_abilities.has(selected_ability):
		AbilityData.unlocked_abilities.erase(selected_ability)
		AbilityData.update_debug_ability_label.emit()
		add_abilities_in_button()
		AbilityData.update_unlock_ability_buttons.emit()

	else:
		print("Ability al verwijderd")
