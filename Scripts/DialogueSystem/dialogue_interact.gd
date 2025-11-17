extends Node2D

@export var dialogue: DialogueResource

@onready var dial_scene : DialogueScene = get_tree().current_scene.get_node("DialogueUI")

var player_in_area := false
var can_interact: bool = true
const INTERACT_COOLDOWN := .5

func _start_npc_interaction():
	DialogueManager.start_dialogue(dialogue)

func _on_npc_dialogue_ended():
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	$Label.visible = true
	player_in_area = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	$Label.visible = false
	player_in_area = false

func _input(event):
	if event.is_action_pressed("Interact"):
		if player_in_area and dialogue and can_interact:
			can_interact = false
			_start_npc_interaction()
			await get_tree().create_timer(INTERACT_COOLDOWN).timeout
			can_interact = true
