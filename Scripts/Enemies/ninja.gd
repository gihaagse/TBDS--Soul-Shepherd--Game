extends enemy

class_name ninja_enemy

func _ready() -> void:
	projectile = load("res://Scenes/Weapons/shuriken.tscn")
	super._ready()
