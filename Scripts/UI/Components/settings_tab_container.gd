class_name SettingsTabContainer
extends Control

@onready var tab_container: TabContainer = $TabContainer as TabContainer

#signal Exit_options_Menu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TabContainer/Graphics/MarginContainer/ScrollContainer/VBoxContainer/Window_Mode_Button.grab_focus()
	OptionsManager._set_focus_all_on_children(self)


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
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/UI/GameMenus/Start_Menu.tscn")
	
	pass
