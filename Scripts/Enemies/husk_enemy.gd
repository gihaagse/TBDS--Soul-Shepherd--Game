extends enemy

class_name husk_enemy

func _ready() -> void:
	projectile = load("res://Scenes/Weapons/rock.tscn")
	super._ready()
