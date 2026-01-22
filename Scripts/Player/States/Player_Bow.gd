extends PlayerState
class_name Player_Bow

@onready var main = get_tree().get_root().get_node("Level")
@onready var projectile = load("res://Scenes/Weapons/hat_projectile.tscn")

func Enter():
	super()
	in_anim = true
	sprite.play("Panda_Throw")
	AbilityData.start_cooldown(AbilityData.ability_list.Archery)
func Exit():
	shoot()

func Update(_delta:float):
	if Input.get_axis("Left", "Right") == 0 and !in_anim:
		state_transition.emit(self, "Idling")
	if Input.get_axis("Left","Right") and !in_anim:
		state_transition.emit(self, "Walking")
	if Input.is_action_just_pressed("Shift") and !in_anim:
		state_transition.emit(self, "Dash")

func shoot():
	var instance = projectile.instantiate()
	instance.sprite = sprite
	instance.player = player
	instance.spawnpos = shootPoint.global_position
	instance.turn_on_area.append(2)
	PlayerPro.projectile = instance
	main.add_child.call_deferred(instance)

func Phys_Update(_delta:float):
	movement(_delta)

func _on_animated_sprite_2d_animation_finished() -> void:
	in_anim =false
