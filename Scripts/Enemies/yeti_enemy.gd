extends enemy

class_name yeti_enemy

func _ready() -> void:
	projectile = load("res://Scenes/Weapons/snowball.tscn")
	super._ready()
