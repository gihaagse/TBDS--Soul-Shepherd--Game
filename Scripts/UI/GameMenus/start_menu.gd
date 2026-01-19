extends Control
#@onready var options_button: Button = $VBoxContainer/Options
@onready var options_menu: OptionsMenu = $OptionsMenu as OptionsMenu
@onready var v_box_container: VBoxContainer = $VBoxContainer as VBoxContainer

@onready var continue_panel: ColorRect = $ContinuePanel
@onready var continue_timer: Timer = $ContinueTimer
@onready var continue_text_label: RichTextLabel = $ContinuePanel/ContinueTextLabel

var full_text := """This is your first time playing the game.


You will start at the tutorial level."""

var current_char := 0
var typing_complete := false

var _last_focused: Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options_menu.exit_options_menu.connect(on_exit_options_menu)
	v_box_container.visible = true
	OptionsManager._set_focus_all_on_children(self)
	$VBoxContainer/Start.call_deferred("grab_focus")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	SaveData.reset_game()
	SaveData.saving.emit()
	continue_panel.visible = true
	continue_text_label.text = ""  
	current_char = 0
	_type_text()
	
		
	#$Panel2.visible = true
	#$GameStartTimer.start()

func _on_continue_pressed() -> void:
	#print("continuing...")
	var section := SaveData.get_last_section()  
	var scene_path := "res://Scenes/Level/level_%s.tscn" % section 
   
	if section == "0-0":  
		continue_panel.visible = true
		continue_text_label.text = ""  
		current_char = 0
		_type_text()
		return

	if ResourceLoader.exists(scene_path):
		get_tree().change_scene_to_file.bind(scene_path).call_deferred()
	else:
		get_tree().change_scene_to_file.bind("res://Scenes/Level/level_0-0.tscn").call_deferred()



func _on_options_pressed() -> void:
	v_box_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true
	$Logo.visible = false
	options_menu.focus_on_default()
	

func on_exit_options_menu() -> void:
	v_box_container.visible = true
	options_menu.set_process(false)
	options_menu.visible = false
	$Logo.visible = true
	regain_menu_focus()

func _on_exit_pressed() -> void:
	get_tree().quit()
	
func _on_any_button_focus_entered():
	_last_focused = get_viewport().gui_get_focus_owner()

func regain_menu_focus():
	if _last_focused and is_instance_valid(_last_focused):
		_last_focused.call_deferred("grab_focus")
	else:
		$VBoxContainer/Start.call_deferred("grab_focus")
		
		
func _on_game_start_timer_timeout() -> void:
	get_tree().change_scene_to_file.bind("res://Scenes/Level/level_0-0.tscn").call_deferred()
	#get_tree().change_scene_to_file("res://Scenes/Level/playtest2.tscn")d
	Engine.time_scale = 1


func _type_text():
	if current_char < full_text.length():
		continue_text_label.text += full_text[current_char]
		current_char += 1
		continue_timer.start(0.03)
	else:
		typing_complete = true  
		continue_timer.stop()   
		continue_timer.start(2.0)


func _on_continue_timer_timeout():
	if not typing_complete: 
		_type_text()
	else:
		continue_panel.visible = false
		$Panel2.visible = true
		$GameStartTimer.start()
