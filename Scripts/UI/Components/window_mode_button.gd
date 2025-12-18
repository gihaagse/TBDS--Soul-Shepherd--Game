extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton as OptionButton

const WINDOW_MODE_ARRAY : Array[String] = [
	"Full-Screen",
	"Window Mode",
	"Bordereless Window",
	"Borderless Full-Screen",
	
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_options_mode_items()
	option_button.item_selected.connect(on_window_mode_selected)
	select_current_window_mode()
	connect("focus_entered", _on_focus_entered)

func add_options_mode_items() -> void:
	for window_mode in WINDOW_MODE_ARRAY:
		option_button.add_item(window_mode)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func on_window_mode_selected(index : int) -> void:
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #Window Mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: #Borderless Window Mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: #Borderless Fulscreen Mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func select_current_window_mode() -> void:
	var mode = DisplayServer.window_get_mode()
	var borderless = DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)
	match mode:
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			if borderless:
				option_button.select(3)
			else:
				option_button.select(0)
		DisplayServer.WINDOW_MODE_WINDOWED:
			if borderless:
				option_button.select(2)
			else:
				option_button.select(1)
		_:
			pass

func _on_focus_entered():
	option_button.grab_focus()
