extends Node

@export var slots : Array[Node2D]
@onready var game_manager: Node = $"../../GameManager"
var index : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for slot in slots:
		slot.visible = false
	slots[index].visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	slots[index].visible = true
	for slot in slots:
		if Input.is_action_just_pressed(str(slot.get_index() + 1)):
			slots[index].visible = false
			index = slot.get_index()
			slots[index].visible = true
			game_manager.updateEquip(slots[index].name)
