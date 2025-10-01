extends PlayerState
class_name Player_Walk

func Enter():
	super()
	sprite.play("Walk")

func Update(_delta:float):
	if not player.is_on_floor():
		state_transition.emit(self, "Falling")
	
	if Input.is_action_just_pressed("LeftClick"):
		state_transition.emit(self, "Attack1")
	if Input.is_action_just_pressed("Shift"):
		state_transition.emit(self, "Dash")
	if Input.is_action_just_pressed("RightClick"):
		state_transition.emit(self, "Archery")

func Phys_Update(_delta:float):
	movement(_delta)
	
	if Input.get_axis("Left", "Right") == 0:
		state_transition.emit(self, "Idling")
