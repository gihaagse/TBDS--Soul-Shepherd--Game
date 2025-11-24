extends Control
class_name CheckPointRespawnUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CheckPointManager.player_died.connect(_on_player_died)

func _on_player_died():
	if not visible:
		visible = true

func _on_choice_made(perefernce_checkpoint: String):
	visible = false
	CheckPointManager.player_choice.emit(perefernce_checkpoint)

func _on_begin_pressed() -> void:
	_on_choice_made("begin")

func _on_closest_pressed() -> void:
	_on_choice_made("closest")


func _on_furthest_pressed() -> void:
	_on_choice_made("furthest")
