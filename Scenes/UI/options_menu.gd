extends Control
class_name OptionsMenu

#signal exit_options_menu
@onready var exit_button: Button = $MarginContainer/VBoxContainer/Exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit_button.button_down.connect(on_exit_pressed)
	#set_process(false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_exit_pressed() -> void:
	#exit_options_menu.emit()
	#set_process(false)
	get_tree().change_scene_to_file("res://Scenes/UI/Start_Menu.tscn")

	
