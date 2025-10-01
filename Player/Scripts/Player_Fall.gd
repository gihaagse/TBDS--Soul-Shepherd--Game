extends PlayerState
class_name Player_Fall
@export var double_jumps_left : int = 1
func Enter():
	super()
	sprite.play("Jump")

func Update(_delta:float):
	if player.is_on_floor():
		state_transition.emit(self, "Idling")
		double_jumps_left = 1
	if Input.is_action_just_pressed("LeftClick"):
		state_transition.emit(self, "AirAttack1")
	if Input.is_action_just_pressed("Shift"):
		state_transition.emit(self, "Dash")
	if Input.is_action_just_pressed("RightClick"):
		state_transition.emit(self, "Archery")
	if Input.is_action_pressed("WallSlide") and player.is_on_wall_only():
		state_transition.emit(self, "WallSliding")
	#if Input.is_action_just_pressed("Jump") and player.is_on_floor() == false:
		#state_transition.emit(self, "DoubleJump")
	if Input.is_action_just_pressed("Jump") and player.is_on_wall_only() and Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
		state_transition.emit(self, "WallJump")

func Phys_Update(_delta:float):
	if Input.is_action_just_pressed("Jump") and not player.is_on_floor() and double_jumps_left:
		player.velocity.y = -jump_force
		double_jumps_left -= 1
	movement(_delta)
