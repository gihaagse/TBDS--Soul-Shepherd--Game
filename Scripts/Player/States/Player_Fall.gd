extends PlayerState
class_name Player_Fall

var double_jumps_left : int

@export var extra_jumps : int = 1
@export var dash_cooldown : Timer
@export var landing_sfx : AudioStreamPlayer2D

@export var max_landing_shake : float = 3
@export var min_landing_shake : float = 0.15
@export var max_blur_strength : float =  0.008
@export var min_blur_strength : float =  0.001
@export var max_duration : float =  0.38
@export var min_duration : float =  0.03
@export var max_landing_volume : float = 10
@export var min_landing_volume : float = -10
@export var max_squash_str : float =  0.4
@export var min_squash_str : float =  0.1
@export var max_squash_duration : float =  0.35
@export var min_squash_duration : float =  0.15

var last_velocity_y : float = 0.0

func Enter():
	super()
	double_jumps_left = extra_jumps
	sprite.play("Panda_Jump")
	last_velocity_y = 0.0

func Update(_delta:float) -> void:
	if player.velocity.y > 0:
		last_velocity_y = player.velocity.y

	if player.is_on_floor():
		_play_landing_effects()
		state_transition.emit(self, "Idling")
		double_jumps_left = extra_jumps

	if Input.is_action_just_pressed("LeftClick") and get_item_by_name("Weapon", slots).visible:
		state_transition.emit(self, "Attack1")
	if Input.is_action_just_pressed("Shift") and dash_cooldown.is_stopped():
		state_transition.emit(self, "Dash")
	if Input.is_action_just_pressed("LeftClick") and get_item_by_name("Bow", slots).visible:
		state_transition.emit(self, "Archery")
	if Input.is_action_pressed("WallSlide") and player.is_on_wall_only():
		state_transition.emit(self, "Wallsliding")
	if Input.is_action_just_pressed("Jump") and player.is_on_wall_only() and (Input.is_action_pressed("Left") or Input.is_action_pressed("Right")):
		state_transition.emit(self, "WallJump")

func Phys_Update(_delta:float) -> void:
	if Input.is_action_just_pressed("Jump") and not player.is_on_floor() and double_jumps_left > 0:
		player.velocity.y = -jump_force
		double_jumps_left -= 1
	movement(_delta)

func _play_landing_effects() -> void:
	var animated_sprite : AnimatedSprite2D = player.get_node("AnimatedSprite2D")
	
	var intensity : float = clamp(last_velocity_y / 800.0, 0.0, 1.0)
	
	var shake_amount : float = lerp(min_landing_shake, max_landing_shake, intensity)
	var blur_amount : float = lerp(min_blur_strength, max_blur_strength, intensity)
	var duration : float = lerp(min_duration, max_duration, intensity)
	var volume : float = lerp(min_landing_volume, max_landing_volume, intensity)
	var squash_duration : float = lerp(min_squash_duration, max_squash_duration, intensity)
	var squash_str : float = lerp(min_squash_str, max_squash_str, intensity)
	
	UtilsEffect.screenshake(level_camera, shake_amount, duration, 25.0)
	UtilsEffect.apply_directional_blur(animated_sprite, duration, blur_amount, 45)
	landing_sfx.volume_db = linear_to_db(volume)
	landing_sfx.play()
	UtilsEffect.squash(sprite, squash_duration, squash_str)
