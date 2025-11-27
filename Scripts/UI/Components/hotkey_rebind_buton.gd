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
		
	set_process_unhandled_input(can)
	set_process_unhandled_key_input(can)


func _unhandled_input(event: InputEvent) -> void:
	if !(event is InputEventMouseMotion) and !(event is InputEventJoypadMotion):
		rebind_action_key(event)
		button.button_pressed = false
		controller_input_button.button_pressed = false


func rebind_action_key(event) -> void:
	var is_keyboard_or_mouse := event is InputEventKey or event is InputEventMouseButton

	# Oude events van de action ophalen
	var old_events = InputMap.action_get_events(action_name)

	# Nieuwe lijst maken waarin we events bewaren die niet overschreven moeten worden
	var filtered_events = []

	for old_event in old_events:
		var old_is_keyboard_or_mouse := old_event is InputEventKey or old_event is InputEventMouseButton

		# Alleen events bewaren die niet hetzelfde type zijn als het nieuwe event
		if old_is_keyboard_or_mouse != is_keyboard_or_mouse:
			filtered_events.append(old_event)

	# Eerst alle events van de actie verwijderen
	InputMap.action_erase_events(action_name)

	# De gefilterde events weer toevoegen (input events van het andere type blijven intact)
	for e in filtered_events:
		InputMap.action_add_event(action_name, e)

	# Nu het nieuwe event toevoegen (overschrijft alleen het corresponderende inputtype)
	InputMap.action_add_event(action_name, event)

	# Input gereedmelding
	set_can_rebind(false)

	# UI updaten met nieuwe bindings
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
	assert(InputMap.has_action(action_name), "There is no action called %s" % [action_name])
	
	for action_event in action_events:
		if action_event is InputEventJoypadButton:
			var btn_index = action_event.button_index
			var btn_name = get_joypad_button_string(btn_index)
			controller_input_button.text = btn_name
			break
			
	var joypadButton
	var joypadMotion
	
	for action_event in action_events:
		if action_event is InputEventMouseButton:
			pass
			
		elif action_event is InputEventJoypadButton:
			var btn_index = action_event.button_index
			var btn_name = get_joypad_button_string(btn_index)
			joypadButton = btn_name
			
		elif action_event is InputEventJoypadMotion:
			joypadMotion = get_joypad_motion_name(action_event)
		else:
			pass
				
		controller_input_button.text = "%s %s" % [joypadButton, "" if not joypadMotion else " or " + joypadMotion]


func get_joypad_button_string(button_index: int) -> String:
	var names = {
		0: "A/Cross",
		1: "B/Circle",
		2: "X/Square",
		3: "Y/Triangle",
		
		4: "Back",
		5: "Home",
		6: "Options",
		
		7: "LS/L3",
		8: "RS/R3",
		
		9: "LB/L1",
		10: "RB/R1",
		
		11: "D-Pad Up",
		12: "D-Pad Down",
		13: "D-Pad Left",
		14: "D-Pad Right"
	}
	return names.get(button_index, "Unknown Button %d" % button_index)


func get_joypad_motion_name(event: InputEventJoypadMotion) -> String:
	match event.axis:
		0:
			return "LS Horizontal"
		1:
			return "LS Vertical"
		2:
			return "RS Horizontal"
		3:
			return "RS Vertical"
		4:
			return "Left Trigger"
		5:
			return "Right Trigger"
		_:
			return "Unknown Axis"
