extends PlayerState
class_name Player_Attack1
@onready var bamboo_stick: Sprite2D = $"../../Bamboo_Stick"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var player_cosmetics: AnimatedSprite2D = $"../../Player_Cosmetics"

var done : bool

func Enter():
	super()
	AbilityData.start_cooldown(AbilityData.ability_list.Attack1)

	in_anim = true
	#sprite.play("Attack_old")
	bamboo_stick.visible = true
	player_cosmetics.visible = true
	if last_character_orientation > 0:
		animation_player.play("AttackAnimation_Right")
		player_cosmetics.rotation_degrees = 90
		bamboo_stick.flip_h = true
	elif last_character_orientation < 0:
		animation_player.play("AttackAnimation_Left")
		bamboo_stick.flip_h = false
	else:
		animation_player.play("AttackAnimation_Right")


		
func Update(_delta:float):
	if Input.get_axis("Left", "Right") == 0 and !in_anim:
		state_transition.emit(self, "Idling")
		
	if Input.get_axis("Left","Right") and !in_anim:
		state_transition.emit(self, "Walking")

func Phys_Update(_delta:float):
	var sprite_rotation = sprite.rotation
	player_cosmetics.rotation = sprite_rotation
	
	movement(_delta)

#func _on_animated_sprite_2d_animation_finished() -> void:
	#bamboo_stick.visible = false
	#in_anim = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	bamboo_stick.visible = false
	player_cosmetics.visible = false
	in_anim = false
