extends PlayerState
class_name Player_Attack1


var done : bool
func Enter():
	super()
	in_anim = true
	sprite.play("Attack")
	
func Update(_delta:float):
	if Input.get_axis("Left", "Right") == 0 and !in_anim:
		state_transition.emit(self, "Idling")
		
	if Input.get_axis("Left","Right") and !in_anim:
		state_transition.emit(self, "Walking")

func Phys_Update(_delta:float):
	movement(_delta)

func _on_animated_sprite_2d_animation_finished() -> void:
	in_anim = false
