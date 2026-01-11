extends Node

const SAVE_LOCATION := "user://SaveFile.save"
signal saving

var save_contents: Dictionary = {
	"max_level": 1,
	"max_part": 1
}

func _ready() -> void:
	_load()

func save() -> void:
	var file := FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
	if file == null:
		return
	file.store_var(save_contents)
	file.close()

func _load() -> void:
	if not FileAccess.file_exists(SAVE_LOCATION):
		return

	var file := FileAccess.open(SAVE_LOCATION, FileAccess.READ)
	if file == null:
		return

	var data: Variant = file.get_var()
	file.close()

	if data is Dictionary:
		save_contents = data

func set_level_progress(level: int, part: int) -> void:
	saving.emit()
	var current_l: int = int(save_contents["max_level"]) 
	var current_p: int = int(save_contents["max_part"])  
	
	if level > current_l or (level == current_l and part > current_p):
		save_contents["max_level"] = level
		save_contents["max_part"] = part
		save()

func reset_game() -> void:
	saving.emit()
	save_contents = {
		"max_level": 1,
		"max_part": 1
	}
	save()

func get_max_level() -> int:
	return int(save_contents["max_level"])

func get_max_part() -> int:
	return int(save_contents["max_part"])

func get_last_section() -> String:
	return "%d-%d" % [int(save_contents["max_level"]), int(save_contents["max_part"])]
