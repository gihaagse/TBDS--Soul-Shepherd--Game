extends Node

enum DoorID {DOOR1, DOOR2, DOOR3, DOOR4, DOOR5 }
enum LevelID {LEVEL1_1, LEVEL1_2, LEVEL1_3, LEVEL2_1, LEVEL2_2, LEVEL2_3 }

var key_scene: PackedScene = preload("res://Scenes/Items/key.tscn")
var current_active_key
var keys_per_level: Dictionary = {}  

func has_key(level_id: LevelID, door_id: DoorID) -> bool:
	var level_doors = keys_per_level.get(level_id, {})
	return level_doors.get(door_id, false)

func collect_key(level_id: LevelID, door_id: DoorID, body: Node2D) -> void:
	print("Collected body: ", body)
	if not keys_per_level.has(level_id):
		keys_per_level[level_id] = {}
	keys_per_level[level_id][door_id] = true
	add_following_key(body)
	
func add_following_key(player: Node2D) -> void:
	var following_key = key_scene.instantiate()
	current_active_key = following_key
	following_key.add_key_to_player(player)

func remove_following_key() -> void:
	if current_active_key:
		current_active_key.queue_free()
