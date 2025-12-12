extends Area2D

@export var level_name : String

func _on_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Scenes/Level/" + str(level_name) + ".tscn")
	CheckPointManager.reset_checkpoints()
	
	AbilityData.reset_abilities()
