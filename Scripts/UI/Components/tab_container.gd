extends TabContainer

func _ready() -> void:
	_focus_current_tab()
	tab_changed.connect(_on_tab_changed)
	OptionsManager._set_focus_all_on_children(self)

func _on_tab_changed(_tab: int) -> void:
	_focus_current_tab()

func _focus_current_tab() -> void:
	var tab_index := get_current_tab()
	if tab_index < 0:
		tab_index = 0
	if tab_index >= get_tab_count():
		return

	var tab_control := get_tab_control(tab_index)
	if tab_control == null:
		return

	var first_control := tab_control.get_node_or_null("ScrollContainer/VBoxContainer/Window_Mode_Button")
	if first_control:
		first_control.grab_focus()
