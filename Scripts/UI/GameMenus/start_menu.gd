extends Control
#@onready var options_button: Button = $VBoxContainer/Options
@onready var options_menu: OptionsMenu = $OptionsMenu as OptionsMenu
@onready var v_box_container: VBoxContainer = $VBoxContainer as VBoxContainer
@onready var game_title: Label = $GameTitle


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options_menu.exit_options_menu.connect(on_exit_options_menu)
	v_box_container.visible = true
	$VBoxContainer/Start.grab_focus()
	OptionsManager._set_focus_all_on_children(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	$Panel2.visible = true
	$GameStartTimer.start()

func _on_customized_pressed() -> void:
	print("This scene does not exist yet")


func _on_options_pressed() -> void:
	v_box_container.visible = false
	game_title.visible = false
	options_menu.set_process(true)
	options_menu.visible = true
	

func on_exit_options_menu() -> void:
	v_box_container.visible = true
	game_title.visible = true
	options_menu.set_process(false)
	options_menu.visible = false

func _on_exit_pressed() -> void:
	get_tree().quit()
	


func _on_game_start_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level/playtest2.tscn")
	Engine.time_scale = 1
