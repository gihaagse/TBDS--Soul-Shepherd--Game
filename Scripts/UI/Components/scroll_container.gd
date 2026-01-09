extends ScrollContainer

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_down"):
		@warning_ignore("narrowing_conversion")
		scroll_vertical += 500 * delta
	if Input.is_action_pressed("ui_up"):
		@warning_ignore("narrowing_conversion")
		scroll_vertical -= 500 * delta
