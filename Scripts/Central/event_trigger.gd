extends Area2D
class_name Trigger

@export var tip : String
@export var tip_label : Label
@onready var events: AnimationPlayer = $".."

func _ready():
	tip = tip.replace("\\n", "\n")

func _on_body_entered(body: Node2D) -> void:
	if body is CollisionObject2D:
		if body.collision_layer & (1 << 2) or body.collision_layer & (1 << 12) and self.name == "Key2":
			events.play(self.name)
