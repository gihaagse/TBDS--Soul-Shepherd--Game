extends PlayerState
class_name Player_Fall
@export var extra_jumps : int = 1
var double_jumps_left
@export var dash_cooldown : Timer

func Enter():
	super()
	double_jumps_left = extra_jumps
	sprite.play("Panda_Jump")

func Update(_delta:float):
	if player.is_on_floor():
		state_transition.emit(self, "Idling")
		double_jumps_left = extra_jumps
	if Input.is_action_just_pressed("LeftClick") and get_item_by_name("Weapon", slots).visible:
		state_transition.emit(self, "Attack1")
	if Input.is_action_just_pressed("Shift") and dash_cooldown.is_stopped():
		state_transition.emit(self, "Dash")
	if Input.is_action_just_pressed("LeftClick") and get_item_by_name("Bow", slots).visible:
		state_transition.emit(self, "Archery")
	if Input.is_action_pressed("WallSlide") and player.is_on_wall_only():
		state_transition.emit(self, "WallSliding")
	if Input.is_action_just_pressed("Jump") and player.is_on_wall_only() and Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
		state_transition.emit(self, "WallJump")

func Phys_Update(_delta:float):
	if Input.is_action_just_pressed("Jump") and not player.is_on_floor() and double_jumps_left:
		player.velocity.y = -jump_force
		double_jumps_left -= 1
	movement(_delta)
