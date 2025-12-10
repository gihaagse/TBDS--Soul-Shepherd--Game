extends Node

const CURSOR_SPEED := 800.0
const DEADZONE := 0.3
var virtual_mouse_pos: Vector2
var mouse_initialized := false


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

	if joy_vec.length() < DEADZONE:
		return

	joy_vec = joy_vec.normalized()

	virtual_mouse_pos += joy_vec * CURSOR_SPEED * delta

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
