extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton as OptionButton

const VSYNC_LABELS: Array[String] = [
	"Off",
	"On",
	"Adaptive"
]

const VSYNC_VALUES: Array[int] = [
	DisplayServer.VSYNC_DISABLED,
	DisplayServer.VSYNC_ENABLED,
	DisplayServer.VSYNC_ADAPTIVE
]

func _ready() -> void:
	option_button.clear()
	for i in VSYNC_LABELS.size():
		option_button.add_item(VSYNC_LABELS[i], i)
	option_button.item_selected.connect(_on_vsync_selected)
	_set_initial_selection()

func _set_initial_selection() -> void:
	var current: int = DisplayServer.window_get_vsync_mode()
	var index: int = VSYNC_VALUES.find(current)
	if index == -1:
		index = 1
	option_button.select(index)

func _on_vsync_selected(index: int) -> void:
	var mode: int = VSYNC_VALUES[index]
	DisplayServer.window_set_vsync_mode(mode)
