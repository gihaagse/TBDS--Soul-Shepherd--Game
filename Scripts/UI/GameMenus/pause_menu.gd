extends Control
@onready var player: CharacterBody2D = $"../../Player"
@onready var options_menu: OptionsMenu = $"../OptionsMenu"
@onready var pause_menu: Control = $"."
@onready var canvas_layer: CanvasLayer = $".."
@onready var resume: Button = $MarginContainer/VBoxContainer/Resume

var _last_focused: Control = resume

signal option_pressed

func _ready() -> void:
	options_menu.exit_options_menu.connect(on_exit_options_menu)
	OptionsManager._set_focus_all_on_children(self)
	$MarginContainer/VBoxContainer/Resume.call_deferred("grab_focus")



# Called every frame. 'delta' ids the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_continue_pressed() -> void:
	canvas_layer.pauseMenu()

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/GameMenus/Start_Menu.tscn")
	#get_tree().set_pause(false)
	

func _on_options_pressed() -> void:
	options_menu.set_process(true)
	options_menu.visible = true
	pause_menu.visible = false
	
func on_exit_options_menu() -> void:
	options_menu.set_process(false)
	options_menu.visible = false
	pause_menu.visible = true
	regain_menu_focus()
	
func _on_any_button_focus_entered():
	_last_focused = get_viewport().gui_get_focus_owner()

func regain_menu_focus():
	if _last_focused and is_instance_valid(_last_focused):
		_last_focused.call_deferred("grab_focus")
	else:
		$VBoxContainer/Start.call_deferred("grab_focus")
