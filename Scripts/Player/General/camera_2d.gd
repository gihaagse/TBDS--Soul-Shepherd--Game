extends Camera2D
class_name CameraMain

@export var player : CharacterBody2D

func _process(_delta: float) -> void:
	global_position = player.global_position
