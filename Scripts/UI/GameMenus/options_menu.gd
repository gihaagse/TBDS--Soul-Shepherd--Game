extends Control
class_name OptionsMenu

signal exit_options_menu
@onready var exit_button: Button = $MarginContainer/VBoxContainer/Exit as Button
@onready var settings_tab_container: SettingsTabContainer = $MarginContainer/VBoxContainer/Settings_Tab_Container

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit_button.button_down.connect(on_exit_pressed)
	set_process(false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	settings_tab_container.set_process(true)
	
func on_exit_pressed() -> void:
	settings_tab_container.set_process(false)
	exit_options_menu.emit()
	set_process(false)
	#get_tree().change_scene_to_file("res://Scenes/UI/Start_Menu.tscn")

	
