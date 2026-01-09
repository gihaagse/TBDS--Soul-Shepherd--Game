extends AudioStreamPlayer2D

@export var delay_before_fade: float = 1.0
@export var fade_duration: float = 2.0
@export var fade_target_db: float = -80.0   # basically silent

var _original_db: float
var _current_tween: Tween

func _ready() -> void:
	_original_db = volume_db

func _on_started() -> void:
	_start_fade_sequence()

func _start_fade_sequence() -> void:
	if _current_tween:
		_current_tween.kill()
		_current_tween = null
		
	volume_db = _original_db
	start_fade_sequence.call_deferred()

func start_fade_sequence() -> void:
	await get_tree().create_timer(delay_before_fade).timeout

	if not playing:
		return

	_current_tween = create_tween()
	_current_tween.tween_property(self, "volume_db", fade_target_db, fade_duration)
	await _current_tween.finished
	playing = false
	volume_db = _original_db
