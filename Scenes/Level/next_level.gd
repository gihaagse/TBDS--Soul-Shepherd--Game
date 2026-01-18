extends Area2D

@export var level_name : String
@export var next_level: int = 2
@export var next_part: int = 2
func _on_body_entered(body: Node2D) -> void:
	AbilityData.reset_abilities()
	get_tree().change_scene_to_file("res://Scenes/Level/" + str(level_name) + ".tscn")
	CheckPointManager.reset_checkpoints()
	SaveData.set_level_progress(next_level, next_part)
