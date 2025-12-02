extends Area2D
class_name  CheckPoint

@export var checkppoint_id : int
@export var checkpoint_marker : Marker2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		CheckPointManager.checkpoint_unlocked(self)
