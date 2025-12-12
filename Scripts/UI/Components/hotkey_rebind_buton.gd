class_name HotkeyRebindButton
extends Control

@onready var label: Label = $HBoxContainer/Label as Label
@onready var button: Button = $HBoxContainer/Button as Button
@onready var controller_input_button: Button = $HBoxContainer/ControllerInputButton

@export var action_name : String = "Left"

var can_rebind: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_can_rebind(false)
	
	set_action_name()
	set_text_for_keyboard_key()
	set_text_for_controller_key()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_action_name() -> void:
	label.text = "Unassigned"
	match action_name:
		"Left":
			label.text = "Move Left"
		"Right":
			label.text = "Move Right"
		"Jump":
			label.text = "Jump"
		"Shift":
			label.text = "Dash"
		"Interact":
			label.text = "Interact"
		"LeftClick": 
			label.text = "Sword Attack"
		"RightClick": 
			label.text = "Hat Throw"
		"Grapple": 
			label.text = "Grapple"

func set_text_for_keyboard_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	assert(InputMap.has_action(action_name), "There is no action called %s" % [action_name])
	
	var keycode_name
	var second_keycode_name
	
	for action_event in action_events:
		if action_event is InputEventMouseButton:
			keycode_name = "Mouse %s" %action_event.button_index
			
		elif action_event is InputEventJoypadButton:
			pass
		elif action_event is InputEventJoypadMotion:
			pass
		else:
			if keycode_name:
				second_keycode_name = OS.get_keycode_string(action_event.physical_keycode)
			else:
				keycode_name = OS.get_keycode_string(action_event.physical_keycode)
				
		button.text = "%s %s" % [keycode_name, "" if not second_keycode_name else " or " + second_keycode_name]


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		button.text = "Press any key..."
		set_can_rebind(toggled_on)
		
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.get_node("HBoxContainer/ControllerInputButton").toggle_mode = false
				i.set_can_rebind(false)
	else:
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.get_node("HBoxContainer/ControllerInputButton").toggle_mode = true
				i.set_can_rebind(false)
	
		set_text_for_keyboard_key()


func set_can_rebind(can: bool)-> void:
	if can:
		can_rebind = can
	set_process_input(can) 


func _input(event: InputEvent) -> void:
	if not can_rebind:
		return
		
	if event is InputEventMouseMotion:
		return  
	
	if event is InputEventJoypadMotion:
		if abs(event.axis_value) < 0.8: 
			return
	
	rebind_action_key(event)
	button.button_pressed = false
	controller_input_button.button_pressed = false
	
	get_viewport().set_input_as_handled()  


func rebind_action_key(event: InputEvent) -> void:
	var is_keyboard_or_mouse := event is InputEventKey or event is InputEventMouseButton
	var is_joypad := event is InputEventJoypadButton or event is InputEventJoypadMotion

	var old_events = InputMap.action_get_events(action_name)
	var filtered_events: Array = []

	for old_event in old_events:
		var old_is_keyboard_or_mouse := old_event is InputEventKey or old_event is InputEventMouseButton
		var old_is_joypad := old_event is InputEventJoypadButton or old_event is InputEventJoypadMotion
		
		if is_keyboard_or_mouse and not old_is_keyboard_or_mouse:
			filtered_events.append(old_event) 
		elif is_joypad and not old_is_joypad:
			filtered_events.append(old_event)  

	InputMap.action_erase_events(action_name)
	
	for e in filtered_events:
		InputMap.action_add_event(action_name, e)
	
	InputMap.action_add_event(action_name, event)
	
	set_can_rebind(false)
	set_text_for_keyboard_key()
	set_text_for_controller_key()
	set_action_name()


func _on_controller_input_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		controller_input_button.text = "Press any key..."
		set_can_rebind(toggled_on)
	
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.get_node("HBoxContainer/ControllerInputButton").toggle_mode = false
				i.button.toggle_mode = false
				i.set_can_rebind(false)
	else:
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.get_node("HBoxContainer/ControllerInputButton").toggle_mode = true
				i.button.toggle_mode = true
				i.set_can_rebind(false)
	
		set_text_for_controller_key()


func set_text_for_controller_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	var joypad_button_text = ""
	var joypad_motion_text = ""
	
	for action_event in action_events:
		if action_event is InputEventJoypadButton:
			var btn_index = action_event.button_index
			joypad_button_text = OptionsManager.get_joypad_button_string(btn_index)
			
		elif action_event is InputEventJoypadMotion:
			joypad_motion_text = OptionsManager.get_joypad_motion_name(action_event)
	
	if joypad_button_text and joypad_motion_text:
		controller_input_button.text = "%s or %s" % [joypad_button_text, joypad_motion_text]
	elif joypad_button_text:
		controller_input_button.text = joypad_button_text
	elif joypad_motion_text:
		controller_input_button.text = joypad_motion_text
	else:
		controller_input_button.text = "No input bound"
