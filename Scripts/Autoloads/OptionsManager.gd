extends Node

const CURSOR_SPEED := 1000.0
const DEADZONE := 0.1
var virtual_mouse_pos: Vector2
var mouse_initialized := false
var last_joy_input_time: int = 0

signal input_scheme_changed(scheme: String)

enum Scheme { KEYBOARD_MOUSE, GAMEPAD }
var current_scheme: Scheme = Scheme.KEYBOARD_MOUSE

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	var win_size: Vector2 = Vector2(DisplayServer.window_get_size())
	virtual_mouse_pos = win_size * 0.5
	DisplayServer.warp_mouse(virtual_mouse_pos.round())
	
func is_any_rebinding() -> bool:
	for node in get_tree().get_nodes_in_group("hotkey_button"):
		if node.can_rebind:
			return true
	return false

func _process(delta: float) -> void:
	var joy_vec := Vector2(
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	)

	var raw_length := joy_vec.length()
	if raw_length < DEADZONE:
		return

	last_joy_input_time = Time.get_ticks_msec()

	var direction := joy_vec.normalized()
	var intensity = inverse_lerp(DEADZONE, 1.0, raw_length)
	intensity = ease(intensity, 2.5) 

	virtual_mouse_pos += direction * intensity * CURSOR_SPEED * delta

	var win_size: Vector2 = Vector2(DisplayServer.window_get_size())
	virtual_mouse_pos.x = clamp(virtual_mouse_pos.x, 0.0, win_size.x - 1.0)
	virtual_mouse_pos.y = clamp(virtual_mouse_pos.y, 0.0, win_size.y - 1.0)

	DisplayServer.warp_mouse(virtual_mouse_pos.round())
	
func _set_focus_all_on_children(node: Node) -> void:
	for child in node.get_children():
		if child is Control:
			child.focus_mode = Control.FOCUS_ALL
			if not child.mouse_entered.is_connected(_on_control_mouse_entered):
				child.mouse_entered.connect(_on_control_mouse_entered.bind(child))
		_set_focus_all_on_children(child)
		
func _on_control_mouse_entered(control: Control) -> void:
	control.grab_focus()
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		_set_scheme(Scheme.KEYBOARD_MOUSE)
	elif event is InputEventMouseMotion:
		if Time.get_ticks_msec() - last_joy_input_time < 200:
			return

		if event.velocity.length() > 50:
			_set_scheme(Scheme.KEYBOARD_MOUSE)
			
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if event is InputEventJoypadMotion and abs(event.axis_value) < 0.2:
			return 
		_set_scheme(Scheme.GAMEPAD)

func _set_scheme(new_scheme: Scheme) -> void:
	if current_scheme != new_scheme:
		current_scheme = new_scheme
		emit_signal("input_scheme_changed", "kbm" if new_scheme == Scheme.KEYBOARD_MOUSE else "controller")

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
