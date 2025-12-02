extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	var hp = body.get_node_or_null("Health")
	if hp and hp.has_method("take_damage"):
		print("Working_code :D")
		hp.take_damage(50)
	else:
		print("Broken_code")
