extends Node

const SAVE_LOCATION := "user://SaveFile.save"
signal saving

var save_contents: Dictionary = {
	"max_level": 0,
	"max_part": 0,
	"found_scroll_dialogue": []
}

func _ready() -> void:
	_load()

func save() -> void:
	var file := FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
	if file == null:
		return
	file.store_var(save_contents)
	file.close()
	#debug_print_contents()

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
		if not save_contents.has("found_scroll_dialogue") or not (save_contents["found_scroll_dialogue"] is Array):
			save_contents["found_scroll_dialogue"] = []  


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
		"max_level": 0,
		"max_part": 0,
		"found_scroll_dialogue": []
	}
	save()

func get_max_level() -> int:
	return int(save_contents["max_level"])

func get_max_part() -> int:
	return int(save_contents["max_part"])

func get_last_section() -> String:
	return "%d-%d" % [int(save_contents["max_level"]), int(save_contents["max_part"])]

func get_found_scrolls_text() -> String:
		
	var scrolls = save_contents["found_scroll_dialogue"] as Array
	if scrolls.is_empty():
		return "No scrolls found"
	
	var text = "Found scrolls (%d):\n\n" % scrolls.size()
	for i in range(scrolls.size()):
		var scroll = scrolls[i] as String
		text += "[%d] %s\n\n" % [i+1, scroll]
	
	return text
	
func debug_print_contents():
	print("=== SAVE CONTENTS ===")
	print("max_level: ", save_contents.get("max_level", "MISSING"))
	print("max_part: ", save_contents.get("max_part", "MISSING"))
	print("scrolls count: ", save_contents.get("found_scroll_dialogue", []).size())
	print("scrolls: ", save_contents.get("found_scroll_dialogue", []))
	print("====================")

func debug_read_file_raw():
	var file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
	if file:
		print("Raw file size: ", file.get_length())
		file.seek(0)
		print("Raw bytes: ", file.get_buffer(file.get_length()).hex_encode())
		file.close()
	else:
		print("No save file found")
