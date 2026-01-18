class_name SettingsTabContainer
extends Control

@onready var tab_container: TabContainer = $TabContainer as TabContainer
@onready var continue_level_label: Label = $TabContainer/SaveData/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/ContinueLevelLabel
@onready var lore_label: Label = $TabContainer/SaveData/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer2/LoreLabel

#signal Exit_options_Menu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$TabContainer/Graphics/MarginContainer/ScrollContainer/VBoxContainer/Window_Mode_Button.grab_focus()
	OptionsManager._set_focus_all_on_children(self)
	focus_entered.connect(_on_focus_entered)
	set_process(false)
	SaveData.saving.connect(_update_level_label)
	_update_level_label()
	show_lore()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	options_menu_input()
	
func change_tab(tab : int) -> void:
	tab_container.set_current_tab(tab)
	
func options_menu_input() -> void:
	if OptionsManager.is_any_rebinding():
		return
		
	if Input.is_action_just_pressed("KeyboardArrowRight") or Input.is_action_just_pressed("R1"):
		if tab_container.current_tab >= tab_container.get_tab_count() - 1:
			change_tab(0)
			return
			
		var next_tab = tab_container.current_tab + 1
		change_tab(next_tab)
	if Input.is_action_just_pressed("KeyboardArrowLeft") or Input.is_action_just_pressed("L1"):
		if tab_container.current_tab == 0:
			change_tab(tab_container.get_tab_count() -1)
			return
			
		var previous_tab = tab_container.current_tab -1
		change_tab(previous_tab)
		
	#if Input.is_action_just_pressed("ui_cancel"):
		#get_tree().change_scene_to_file("res://Scenes/UI/GameMenus/Start_Menu.tscn")
	
	pass
	
func _on_focus_entered() -> void:
	var tab_bar: TabBar = tab_container.get_tab_control(0)
	tab_bar.focus_mode = Control.FOCUS_ALL  
	tab_bar.grab_focus()
	#print("From exit", tab_bar)

func show_lore() -> void:
	lore_label.text = SaveData.get_found_scrolls_text()
	
func _on_reset_continue_pressed() -> void:
	SaveData.reset_game()
	SaveData.saving.emit()

func _update_level_label() -> void:
	var section = SaveData.get_last_section()
	if section == "0-0":
		continue_level_label.text = "Last Level: Tutorial"
	else:
		continue_level_label.text = "Last Level: level %s" % section
	show_lore()
