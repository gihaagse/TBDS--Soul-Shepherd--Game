# TestScene.gd
extends Control

@export var test_dialogue: DialogueResource
@onready var start_button = $StartDialogueButton

func _ready():
	start_button.pressed.connect(_on_start_dialogue_pressed)
	
	# Load dialogue UI instantie
	var dialogue_ui_scene = preload("res://Scenes/Dialogue/DialogueUI.tscn")
	var dialogue_ui = dialogue_ui_scene.instantiate()
	add_child(dialogue_ui)

func _on_start_dialogue_pressed():
	if test_dialogue:
		DialogueManager.start_dialogue(test_dialogue)
	else:
		print("No dialogue resource assigned!")
