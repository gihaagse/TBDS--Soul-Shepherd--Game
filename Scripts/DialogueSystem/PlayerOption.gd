# PlayerOption.gd
extends Resource
class_name PlayerOption

@export var choice_text: String = ""
@export var npc_response: DialogueEntry
@export var rewards: Dictionary = {}
