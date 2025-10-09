extends PlayerState
class_name Player_WallSlide
@onready var timer: Timer = $Timer
@export var dash_cooldown : Timer
@export var Wallslide_cap : float = 100  # 20% van normale gravity
func Enter():
	super()
	#sprite.play("WallSlide")

func Update(_delta:float):
	if player.is_on_floor():
		state_transition.emit(self, "Idling")
	if not timer.time_left:
		if player.is_on_wall() == false:
			state_transition.emit(self, "Falling")
		if Input.is_action_pressed("Left") and not sprite.flip_h:
			state_transition.emit(self, "Falling")
		if Input.is_action_pressed("Right") and sprite.flip_h:
			state_transition.emit(self, "Falling")

func Phys_Update(_delta:float):
	if player.velocity.y <= 0:
		player.velocity += player.get_gravity() * _delta
	elif player.velocity.y >Wallslide_cap:
		player.velocity.y = move_toward(player.velocity.y, Wallslide_cap, brake_force)
	else:
		player.velocity.y = Wallslide_cap
		
	if Input.is_action_just_pressed("Jump") and player.is_on_wall_only():
		jumpsfx.playing = true
		var dismount = move_speed if sprite.flip_h else -move_speed
		player.velocity = Vector2(dismount ,-jump_force)
		sprite.flip_h = true if dismount <0 else false
		weapon.position.x = -14 if sprite.flip_h else 14
		timer.start()
	player.move_and_slide()
