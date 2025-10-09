extends Control
#@onready var options_button: Button = $VBoxContainer/Options
#@onready var options_menu: OptionsMenu = $OptionsMenu as OptionsMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#options_menu.exit_options_menu.connect(on_exit_options_menu)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	print("gedrukt op start")
	get_tree().change_scene_to_file("res://Scenes/Level/level_1.tscn")
	Engine.time_scale = 1

func _on_customized_pressed() -> void:
	print("This scene does not exist yet")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/Options_Menu.tscn")
	

#func on_exit_options_menu() -> void:
	#pass

func _on_exit_pressed() -> void:
	get_tree().quit()
