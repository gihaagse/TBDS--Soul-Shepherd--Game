extends PlayerState
class_name Player_Doublejump

func Enter():
	super()
	sprite.play("Panda_Jump")
	jumps_left -= 1
	


func Phys_Update(_delta:float) -> void:
	player.velocity.y = -jump_force
	state_transition.emit(self, "Idling")
	movement(_delta)
