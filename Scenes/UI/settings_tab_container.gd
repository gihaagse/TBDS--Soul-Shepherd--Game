class_name SettingsTabContainer
extends Control

@onready var tab_container: TabContainer = $TabContainer as TabContainer

#signal Exit_options_Menu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	options_menu_input()
	
func change_tab(tab : int) -> void:
	tab_container.set_current_tab(tab)
	
func options_menu_input() -> void:
	if Input.is_action_just_pressed("Right") or Input.is_action_just_pressed("ui_right"):
		if tab_container.current_tab >= tab_container.get_tab_count() - 1:
			change_tab(0)
			return
			
		var next_tab = tab_container.current_tab + 1
		change_tab(next_tab) 
	if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("ui_left"):
		if tab_container.current_tab == 0:
			change_tab(tab_container.get_tab_count() -1)
			return
			
		var previous_tab = tab_container.current_tab -1
		change_tab(previous_tab)
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/UI/Start_Menu.tscn")
	
	pass
