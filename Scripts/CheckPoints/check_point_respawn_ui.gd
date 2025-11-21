extends Control
class_name CheckPointRespawnUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CheckPointManager.player_died.connect(_on_player_died)

func _on_player_died():
	if not visible:
		visible = true

func _on_choice_made(closest: bool):
	visible = false
	CheckPointManager.player_choice.emit(closest)

func _on_closest_pressed() -> void:
	_on_choice_made(true)


func _on_furthest_pressed() -> void:
	_on_choice_made(false)
