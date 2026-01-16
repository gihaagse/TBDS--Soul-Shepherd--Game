extends Control
class_name AudioSlider

@onready var audio_name_lbl: Label = $HBoxContainer/Audio_Name_Lbl as Label
@onready var audio_num_lbl: Label = $HBoxContainer/Audio_Num_Lbl as Label
@onready var h_slider: HSlider = $HBoxContainer/HSlider as HSlider
@onready var preview_player: AudioStreamPlayer = $PreviewPlayer
@onready var six_seven_easter_egg: AudioStreamPlayer = $SixSevenEasterEgg
@onready var timer: Timer = $Timer

@export_enum("Master", "Music", "Sfx")  var bus_name : String

var bus_index := 0
var slider_is_initialized: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_name_label_text()
	get_bus_name_by_index()
	set_slider_value()
	preview_player.bus = AudioServer.get_bus_name(bus_index)
	six_seven_easter_egg.bus = AudioServer.get_bus_name(bus_index)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
	
func set_name_label_text() -> void:
	audio_name_lbl.text = str(bus_name) + " Volume"

func set_audio_num_label_text() -> void:
	audio_num_lbl.text = str(h_slider.value * 100)
	
func get_bus_name_by_index() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	
func set_slider_value() -> void:
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	set_audio_num_label_text()
	
func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	if timer.is_stopped():
		timer.start(0.1)
	set_audio_num_label_text()

		
func _on_timer_timeout() -> void:
	if slider_is_initialized:
		var current_value = h_slider.value
		if preview_player and current_value > 0.01:
			if current_value >= 0.67 and current_value < 0.68:
				six_seven_easter_egg.play()
			else:
				preview_player.play()
	slider_is_initialized = true
