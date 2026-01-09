extends StaticBody2D

@export var door_id: KeyManager.DoorID
@export var level_id: KeyManager.LevelID
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	pass

func key_collect() -> void: 
	KeyManager.collect_key(level_id, door_id, player)
	

func open_door() -> void:
	if KeyManager.has_key(level_id, door_id):
		KeyManager.remove_following_key()
		queue_free()

func _on_unlock_area_body_entered(_body: Node2D) -> void:
	open_door()
