extends PlayerState
class_name Player_AirAttack1

var done : bool
var initial_brake : int = 2
var initial_speed : int = 120
func Enter():
	super()
	in_anim = true
	sprite.play("Attack")
	
func Update(_delta:float):
	if Input.get_axis("Left", "Right") == 0 and !in_anim:
		state_transition.emit(self, "Idling")
		
	if Input.get_axis("Left","Right") and !in_anim:
		state_transition.emit(self, "Walking")
	if Input.is_action_just_pressed("Shift") and !in_anim:
		state_transition.emit(self, "Dash")

func Phys_Update(_delta:float):
	if not player.is_on_floor():
		brake_force = initial_brake
		walk_speed = initial_speed
	else:
		brake_force = 7
		walk_speed = 100
	movement(_delta)

func _on_animated_sprite_2d_animation_finished() -> void:
	in_anim = false
