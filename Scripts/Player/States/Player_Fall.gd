extends PlayerState
class_name Player_Fall

@export var dash_cooldown : Timer
@export var landing_sfx : AudioStreamPlayer2D
@export var extra_hold_jump: float = 6.3
@export var max_jump_hold_time: float = 1.5

@export_group("fx")
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
var fall_hold_time: float = 0.0
var max_fall_hold_time: float = 0.05
var jump_hold_time: float = 0.0
var can_glide : bool


func Enter():
	super()
	if PlayerPro.projectile:
		sprite.play("Panda_Jump_No_Hat")
		can_glide = false
	else:
		sprite.play("Panda_Jump")
		can_glide = true
	if not PlayerPro.projectile_exists.is_connected(_update_bool):
		PlayerPro.projectile_exists.connect(_update_bool)
	last_velocity_y = 0.0
	fall_hold_time = 0.0
	jump_hold_time = 0.0

func Update(_delta:float) -> void:
	if player.velocity.y > 0:
		last_velocity_y = player.velocity.y

	if player.is_on_floor():
		_play_landing_effects()
		jumps_left = max_double_jumps
		can_double_jump = false
		state_transition.emit(self, "Idling")

	#if Input.is_action_just_pressed("LeftClick") and get_item_by_name("Weapon", slots).visible:
	if Input.is_action_just_pressed("LeftClick"):
		state_transition.emit(self, "Attack1")
	if Input.is_action_just_pressed("Shift") and dash_cooldown.is_stopped():
		state_transition.emit(self, "Dash")
	#if Input.is_action_just_pressed("RightClick") and get_item_by_name("Bow", slots).visible:
	if Input.is_action_just_pressed("RightClick") and not PlayerPro.projectile:
		state_transition.emit(self, "Archery")
		
	if Input.is_action_pressed("WallSlide") and player.is_on_wall_only():
		state_transition.emit(self, "Wallsliding")

func Phys_Update(_delta:float) -> void:
	if Input.is_action_just_pressed("Jump") and player.is_on_wall_only() and (Input.is_action_pressed("Left") or Input.is_action_pressed("Right")):
		print("going walljump")
		state_transition.emit(self, "Walljump")
	
	if Input.is_action_pressed("Jump"):
		jump_hold_time += _delta
		if player.velocity.y <0 and jump_hold_time < max_jump_hold_time:
			player.velocity.y -= extra_hold_jump
		
	if Input.is_action_pressed("Jump") and player.velocity.y >=0:

		fall_hold_time += _delta
		if fall_hold_time >= max_fall_hold_time and can_glide:
			state_transition.emit(self, "Airgliding")
			
		if Input.is_action_just_pressed("Jump") and jumps_left > 0 and \
		AbilityData.unlocked_abilities.has(AbilityData.get_value_from_ability_name("Doublejump")):
			state_transition.emit(self, "Doublejump")
			
	elif Input.is_action_just_pressed("Jump") and can_double_jump and jumps_left > 0 and \
	AbilityData.unlocked_abilities.has(AbilityData.get_value_from_ability_name("Doublejump")):
			state_transition.emit(self, "Doublejump")
			
			
	if Input.is_action_just_released("Jump"):
		can_double_jump = true
		
		
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
	
func _update_bool():
	can_glide = true
