extends PlayerState
class_name Player_Walk
@export var dash_cooldown : Timer
func Enter():
	super()
	sprite.play("Panda_Walk")

func Update(_delta:float):
	if not player.is_on_floor():
		state_transition.emit(self, "Falling")
	if Input.is_action_just_pressed("LeftClick") and get_item_by_name("Weapon", slots).visible:
		state_transition.emit(self, "Attack1")
	if Input.is_action_just_pressed("Shift") and dash_cooldown.is_stopped():
		state_transition.emit(self, "Dash")
	if Input.is_action_just_pressed("LeftClick") and get_item_by_name("Bow", slots).visible:
		state_transition.emit(self, "Archery")

func Phys_Update(_delta:float):
	movement(_delta)
	
	if Input.get_axis("Left", "Right") == 0:
		state_transition.emit(self, "Idling")
