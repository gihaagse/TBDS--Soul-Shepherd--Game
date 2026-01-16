extends enemy

class_name monk_enemy

func _ready() -> void:
	projectile = load("res://Scenes/Weapons/fireball.tscn")
	super._ready()
