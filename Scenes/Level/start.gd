extends Marker2D

@export var checkppoint_id : int

func _ready() -> void:
	CheckPointManager.register_start(self)
