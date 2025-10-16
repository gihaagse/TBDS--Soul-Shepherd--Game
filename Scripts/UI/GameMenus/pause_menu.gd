extends Control
@onready var player: CharacterBody2D = $"../../Player"
@onready var options_menu: OptionsMenu = $"../OptionsMenu"
@onready var pause_menu: Control = $"."

signal option_pressed

func _ready() -> void:
	options_menu.exit_options_menu.connect(on_exit_options_menu)



# Called every frame. 'delta' ids the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_continue_pressed() -> void:
	player.pauseMenu()

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/Start_Menu.tscn")
	#get_tree().set_pause(false)
	

func _on_options_pressed() -> void:
	options_menu.set_process(true)
	options_menu.visible = true
	pause_menu.visible = false
	
func on_exit_options_menu() -> void:
	options_menu.set_process(false)
	options_menu.visible = false
	pause_menu.visible = true
