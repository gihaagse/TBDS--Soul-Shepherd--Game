extends Control


@onready var ability_icon: TextureRect = $HBoxContainer/AbilityIconButton/AbilityIcon
@onready var progress_overlay: TextureProgressBar = $HBoxContainer/AbilityIconButton/AbilityIcon/ProgressOverlay
@onready var info_label: Label = $HBoxContainer/IconButtonResizer/InfoLabel
@onready var label_button: Button = $HBoxContainer/IconButtonResizer/LabelButton
@onready var ability_icon_button: Button = $HBoxContainer/AbilityIconButton

signal clicked_on_a_button

var ability_name: String = ""
var ability_description: String = ""
var button_pressed : bool = true

func _ready() -> void:
	clicked_on_a_button.connect(on_button_pressed)

func set_icon(texture: Texture) -> void:
	ability_icon.texture = texture

func set_cooldown_fraction(fraction: float) -> void:
	progress_overlay.value = fraction
	
	
func set_default_info_label_text(ability: int) -> void:
	ability_description = AbilityData.INFO[ability]["description"]
	ability_name = AbilityData.INFO[ability]["name"]
	info_label.text = ability_name
	
func set_minimum_size() -> void:
	var horizontal_size = info_label.get_size().x
	custom_minimum_size.x = horizontal_size * 3


func _on_ability_icon_button_pressed() -> void:
	on_button_pressed()
	
func _on_label_button_pressed() -> void:
	on_button_pressed()

func on_button_pressed() -> void:
	button_pressed = !button_pressed
	var stylebox = label_button.get_theme_stylebox("normal").duplicate()
	
	if button_pressed:
		info_label.text = ability_name
		stylebox.bg_color.a = 100.0/255.0
		label_button.add_theme_stylebox_override("normal", stylebox)
		ability_icon_button.add_theme_stylebox_override("normal", stylebox)
	else:
		info_label.text = ability_description
		stylebox.bg_color.a = 0.8 
		label_button.add_theme_stylebox_override("normal", stylebox)
		ability_icon_button.add_theme_stylebox_override("normal", stylebox)
		
		
