extends Node
#class_name  KeyManagerClass

enum DoorID {DOOR1, DOOR2, DOOR3, DOOR4, DOOR5 }
enum LevelID {LEVEL1_1, LEVEL1_2, LEVEL1_3, LEVEL2_1, LEVEL2_2, LEVEL2_3 }

var keys_per_level: Dictionary = {}  

func has_key(level_id: LevelID, door_id: DoorID) -> bool:
	var level_doors = keys_per_level.get(level_id, {})
	return level_doors.get(door_id, false)

func collect_key(level_id: LevelID, door_id: DoorID) -> void:
	if not keys_per_level.has(level_id):
		keys_per_level[level_id] = {}
	keys_per_level[level_id][door_id] = true
