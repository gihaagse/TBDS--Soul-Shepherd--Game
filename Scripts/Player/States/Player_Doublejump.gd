extends PlayerState
class_name Player_Doublejump

func Enter():
	super()
	sprite.play("Panda_Jump")
	jumps_left -= 1
	


func Phys_Update(_delta:float) -> void:
	jump_effect()
	state_transition.emit(self, "Idling")
	movement(_delta)
