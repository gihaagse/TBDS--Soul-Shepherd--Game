extends PlayerState
class_name Player_Doublejump

func Enter():
	super()
	sprite.play("Panda_Jump")
	AbilityData.start_cooldown(AbilityData.ability_list.DoubleJump)
	jumps_left -= 1
	


func Phys_Update(_delta:float) -> void:
	jump_effect()
	state_transition.emit(self, "Idling")
	movement(_delta)
	
