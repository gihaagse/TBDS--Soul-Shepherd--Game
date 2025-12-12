extends Area2D

@export var tip : String
@export var tip_label : Label

func _ready():
	tip = tip.replace("\\n", "\n")

func _on_body_entered(body: Node2D) -> void:
	tip_label.text = tip
