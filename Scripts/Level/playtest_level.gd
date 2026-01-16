extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var obstacles: Node2D = $Obstacles
	print(obstacles)
	#CheckPointManager.register_root_obstacle(obstacles)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
