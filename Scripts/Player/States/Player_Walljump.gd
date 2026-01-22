extends PlayerState
class_name Player_WallJump
@onready var timer: Timer = $Timer
@export var dash_cooldown : Timer

var wallslide_dust_particle: CPUParticles2D

@export var min_amount : float = 15
@export var max_amount : float = 30


var wall_jump_particle : GPUParticles2D

func Enter():
	super()
	#sprite.play("WallSlide")
	AbilityData.start_cooldown(AbilityData.ability_list.WallJump)

	wallslide_dust_particle = player.get_node("WallslideDustParticle")
	wall_jump_particle = player.get_node("WallJumpParticle")
	
	var direction := Input.get_axis("Left", "Right")
	
	#if Input.is_action_just_released("Jump") and player.is_on_wall_only():
	if wallslide_dust_particle.emitting:
		wallslide_dust_particle.emitting = false
	var animated_sprite = player.get_node("AnimatedSprite2D")
	jumpsfx.playing = true
	UtilsEffect.stretch(sprite, .2, .15)
	UtilsEffect.screenshake(level_camera, 1.75, .1, 28.0)
	UtilsEffect.apply_directional_blur(animated_sprite, .125, 0.005, 25)
	UtilsEffect.camera_zoom(level_camera, Vector2(4.075, 4.075), .15)
	
	wall_jump_particle.emitting = false
	wall_jump_particle.restart()
	wall_jump_particle.emitting = true
	
	if direction > 0:
		wall_jump_particle.position = Vector2(6.0, wall_jump_particle.position.y)
		wall_jump_particle.rotation = -26
	elif direction < 0:
		wall_jump_particle.position = Vector2(-6.0, wall_jump_particle.position.y)
		wall_jump_particle.rotation = 26
		
	var dismount = move_speed if sprite.flip_h else -move_speed
	player.velocity = Vector2(dismount ,-jump_force)
	sprite.flip_h = true if dismount <0 else false
	weapon.position.x = -14 if sprite.flip_h else 14
	timer.start()
	

func Exit():
	wallslide_dust_particle.emitting = false

func Update(_delta:float):
	if player.is_on_floor():
		state_transition.emit(self, "Idling")
	if not Input.get_axis("Left", "Right"):
		state_transition.emit(self, "Falling")
	if not timer.time_left:
		if player.is_on_wall() == false:
			state_transition.emit(self, "Falling")
		if Input.is_action_pressed("Left") and not sprite.flip_h:
			state_transition.emit(self, "Falling")
		if Input.is_action_pressed("Right") and sprite.flip_h:
			state_transition.emit(self, "Falling")

func Phys_Update(_delta:float):
	player.velocity += player.get_gravity() * _delta
		
	player.move_and_slide()
