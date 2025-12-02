extends PlayerState
class_name Player_Airgliding

@export var airglide_gravity: Vector2 = Vector2(0,100)
@export var default_gravity: Vector2 = Vector2(0,980)
@onready var bamboo_glide: AnimatedSprite2D = $"../../Bamboo-glide"

@onready var timer: Timer = $Timer

var hat_offset = Vector2(0,-2)

func Enter():
	super()
	sprite.play("Panda_Jump_No_Hat")
	bamboo_glide.visible = true
	bamboo_glide.play("Hat_glide")
	in_gliding = true
	timer.start()
	
	bamboo_glide.scale.x = 2.0
	timer.connect("timeout", Callable(self, "_flip_sprite"))

func Exit():
	timer.stop()
	bamboo_glide.visible = false
	in_gliding = false
	custom_gravity = default_gravity

func Update(_delta:float) -> void:
	var sprite_rotation_deg = sprite.rotation_degrees
	var angle_rad = deg_to_rad(sprite_rotation_deg)
	var rotated_offset = hat_offset.rotated(angle_rad)
	bamboo_glide.position = sprite.position + rotated_offset
	bamboo_glide.rotation_degrees = sprite_rotation_deg
	

func Phys_Update(_delta:float) -> void:
	if player.is_on_floor_only():
		state_transition.emit(self, "Falling")
			
	if player.velocity.y >= 0:
		custom_gravity = airglide_gravity
	
	if Input.is_action_just_released("Jump"):
		state_transition.emit(self, "Falling")
		
	movement(_delta)
	
func _exit_state() -> void:
	pass
	
func _flip_sprite() -> void:
	sprite.scale.x *= -1
