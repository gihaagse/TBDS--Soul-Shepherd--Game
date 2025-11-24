extends Marker2D

@export var checkppoint_id : int
@export var checkpoint_marker : Marker2D

func _ready() -> void:
	CheckPointManager.register_start(self)
