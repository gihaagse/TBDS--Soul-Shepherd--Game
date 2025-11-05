class_name HotkeyRebindButton
extends Control

@onready var label: Label = $HBoxContainer/Label as Label
@onready var button: Button = $HBoxContainer/Button as Button

@export var action_name : String = "Left"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	assert(InputMap.has_action(action_name), "There is no action called %s" % [action_name])
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	
	button.text = "%s" % action_keycode
	
	#var Event = InputMap.action_get_events(action_name)
	#if Event is Array:
		#Event = Event.front()
	#if not Event == null:
		#button.text = Event.as_text_physical_keycode()


func _on_button_toggled(toggled_on: bool) -> void:
	print(toggled_on)
	if toggled_on:
		button.text = "Press any key..."
		set_process_unhandled_key_input(toggled_on)
	
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)
	else:
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)
	
		set_text_for_key()
		
func _unhandled_key_input(event):
	rebind_action_key(event)
	button.button_pressed = false
	
func rebind_action_key(event) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	
	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()
