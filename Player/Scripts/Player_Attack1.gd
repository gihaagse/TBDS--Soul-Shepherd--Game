extends PlayerState
class_name Player_Attack1

signal taking_Damage

var done : bool
func Enter():
	super()
	in_anim = true
	sprite.play("Attack")
	#taking_Damage.emit(10)
	
func Update(_delta:float):
	if Input.get_axis("Left", "Right") == 0 and !in_anim:
		state_transition.emit(self, "Idling")
		
	if Input.get_axis("Left","Right") and !in_anim:
		state_transition.emit(self, "Walking")
	if Input.is_action_just_pressed("Shift") and !in_anim:
		state_transition.emit(self, "Dash")

func Phys_Update(_delta:float):
	movement(_delta)

func _on_animated_sprite_2d_animation_finished() -> void:
	in_anim = false
