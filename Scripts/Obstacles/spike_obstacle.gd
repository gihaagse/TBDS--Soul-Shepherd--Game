extends Obstacle

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass
	

func apply_effect(body: Node2D) -> void:
	var spikes_sprite = $Spikes
	spikes_sprite.position.y -= 20
