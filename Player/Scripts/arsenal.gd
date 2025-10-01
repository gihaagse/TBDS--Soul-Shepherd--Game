extends Node

@export var slots : Array[Node2D]
var active_slot : Area2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for slot in slots:
		slot.visible = false
	active_slot = slots[0]
	active_slot.visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("1"):
		active_slot.visible = false
		active_slot = slots[0]
		active_slot.visible = true
	if Input.is_action_just_pressed("2"):
		active_slot.visible = false
		active_slot = slots[1]
		active_slot.visible = true
