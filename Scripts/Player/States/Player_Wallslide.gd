extends PlayerState
class_name Player_WallSlide
@onready var timer: Timer = $Timer
@export var dash_cooldown : Timer
@export var Wallslide_cap : float = 100  # 20% van normale gravity

var wallslide_dust_particle: CPUParticles2D

@export var min_amount : float = 15
@export var max_amount : float = 30

var wallslide_particle_timer : float = 0
@export var wallside_particle_cap: float = .35

var wall_jump_particle : GPUParticles2D

func Enter():
	super()
	#sprite.play("WallSlide")
	wallslide_dust_particle = player.get_node("WallslideDustParticle")
	wall_jump_particle = player.get_node("WallJumpParticle")

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
	if player.velocity.y <= 0:
		player.velocity += player.get_gravity() * _delta
	elif player.velocity.y > Wallslide_cap:
		player.velocity.y = move_toward(player.velocity.y, Wallslide_cap, brake_force)
	else:
		player.velocity.y = Wallslide_cap
	
	var direction := Input.get_axis("Left", "Right")
	_play_wallslide_effects(_delta, direction)
	
	if Input.is_action_just_pressed("Jump") and player.is_on_wall_only():
		wallslide_particle_timer = 0
		if wallslide_dust_particle.emitting:
			wallslide_dust_particle.emitting = false
		
		state_transition.emit(self, "Walljump")
		weapon.position.x = -14 if sprite.flip_h else 14
		timer.start()
	player.move_and_slide()

func _play_wallslide_effects(_delta:float, direction: float) -> void:
	wallslide_particle_timer += _delta
	if wallslide_particle_timer <= wallside_particle_cap:
		wallslide_dust_particle.emitting = false
		return
	
	#var intensity : float = clamp(player.velocity.y / 800.0, 0.0, 1.0)
	#var _amount : int = int(ceil(lerp(min_amount, max_amount, intensity)))
	#wallslide_dust_particle.amount = _amount
	
	wallslide_dust_particle.direction = Vector2(direction, wallslide_dust_particle.direction.y)
	
	if direction > 0:
		wallslide_dust_particle.position.x = 5
		wallslide_dust_particle.orbit_velocity_min = 0.5
		wallslide_dust_particle.orbit_velocity_max = 0.5
		wallslide_dust_particle.rotation = -25
		wallslide_dust_particle.emitting = true
	elif direction < 0:
		wallslide_dust_particle.position.x = -5
		wallslide_dust_particle.orbit_velocity_min = -0.5
		wallslide_dust_particle.orbit_velocity_max = -0.5
		wallslide_dust_particle.rotation = 25
		wallslide_dust_particle.emitting = true
	else:
		wallslide_dust_particle.emitting = false
		wallslide_particle_timer = 0
	
