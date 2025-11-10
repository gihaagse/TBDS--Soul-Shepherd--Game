extends PlayerState
class_name Player_Fall


@export var dash_cooldown : Timer
@export var landing_sfx : AudioStreamPlayer2D
@export var max_jump_hold: float = 0.1

@export var max_landing_shake : float = 3
@export var min_landing_shake : float = 0.15
@export var max_blur_strength : float =  0.008
@export var min_blur_strength : float =  0.001
@export var max_duration : float =  0.38
@export var min_duration : float =  0.03
@export var max_landing_volume : float = 25
@export var min_landing_volume : float = -10
@export var max_squash_str : float =  0.4
@export var min_squash_str : float =  0.1
@export var max_squash_duration : float =  0.35
@export var min_squash_duration : float =  0.15

var last_velocity_y : float = 0.0
var jump_hold_time: float = 0.0
var is_jumping: bool = false

func Enter():
	super()
	sprite.play("Panda_Jump")
	last_velocity_y = 0.0
	is_jumping = true

func Update(_delta:float) -> void:
	if player.velocity.y > 0:
		last_velocity_y = player.velocity.y

	if player.is_on_floor():
		_play_landing_effects()
		state_transition.emit(self, "Idling")
		jumps_left = 1

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
		
	if Input.is_action_just_pressed("Jump") and not player.is_on_floor():
		if jumps_left > 0 and AbilityData.unlocked_abilities.has(AbilityData.get_value_from_ability_name("Doublejump")):
			state_transition.emit(self, "Doublejump")
		else:
			state_transition.emit(self, "Airgliding")
		

func Phys_Update(_delta:float) -> void:
	#if Input.is_action_pressed("Jump") and player.velocity.y > 0 and is_jumping:
		#print("")
		#jump_hold_time += _delta
		#if jump_hold_time <= max_jump_hold:
			#player.velocity.y -= jump_force/3
			#print("jump timer: ", jump_hold_time)
			#print("max hold: ", max_jump_hold)
			#player.velocity.y = lerp(player.velocity.y, -jump_force * 3.0, _delta * 2) # vloeiende versterking omhoog
	
	if Input.is_action_just_released("Jump") or jump_hold_time >= max_jump_hold:
		jump_hold_time = 0
		is_jumping = false
		
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
	landing_sfx.volume_db = volume
	landing_sfx.play()
	UtilsEffect.squash(sprite, squash_duration, squash_str)
