extends Area2D

@export var level_name : String
@export var next_level: int = 2
@export var next_part: int = 2

func _on_body_entered(body: Node2D) -> void:
	AbilityData.reset_abilities()
	CheckPointManager.reset_checkpoints()
	SaveData.set_level_progress(next_level, next_part)
	
	var path = "res://Scenes/Level/" + str(level_name) + ".tscn"
	print("Trying to load: ", path)  
	
	if ResourceLoader.exists(path):
		var scene_packed = ResourceLoader.load(path)
		if scene_packed:
			get_tree().change_scene_to_packed(scene_packed)
			print("Scene switched successfully")
		else:
			print("Failed to load scene from path: ", path)
	else:
		print("Scene file does not exist: ", path)
