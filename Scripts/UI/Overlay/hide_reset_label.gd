extends Area2D

@onready var events: AnimationPlayer = $".."

@onready var level_2: Node2D = $"../.."

func _on_body_entered(body: Node2D) -> void:
	if body is CollisionObject2D:
		if body.collision_layer & (1 << 2) or body.collision_layer & (1 << 12):
			events.play(self.name)
