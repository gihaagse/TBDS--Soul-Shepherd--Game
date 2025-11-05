extends Node2D

@export var dialogue: DialogueResource

@onready var dial_scene : DialogueScene = get_tree().current_scene.get_node("DialogueUI")
var player_in_area := false

func _start_npc_interaction():
	if dialogue:
		DialogueManager.start_dialogue(dialogue)
	else:
		print("No dialogue resource assigned!")
	
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	$Label.visible = true
	player_in_area = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	$Label.visible = false
	player_in_area = false

func _input(event):
	if player_in_area and event.is_action_pressed("Interact"):
		_start_npc_interaction()
