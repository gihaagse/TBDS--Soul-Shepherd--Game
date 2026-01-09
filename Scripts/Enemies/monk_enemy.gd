extends enemy

class_name monk_enemy

func _ready() -> void:
	projectile = load("res://Scenes/Weapons/projectile.tscn")
	super._ready()
