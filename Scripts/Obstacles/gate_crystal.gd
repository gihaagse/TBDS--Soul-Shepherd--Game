extends StaticBody2D

@export var door_id: KeyManager.DoorID
@export var level_id: KeyManager.LevelID

func _ready() -> void:
	pass

func key_collect() -> void: 
	print("Key collected: ", level_id, " ", door_id)
	KeyManager.collect_key(level_id, door_id)

func open_door() -> void:
	if KeyManager.has_key(level_id, door_id):
		queue_free()

func _on_unlock_area_body_entered(_body: Node2D) -> void:
	print("Player in area for ", door_id)
	open_door()
