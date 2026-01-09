extends enemy

class_name final_boss

@export var jump_speed: int = -125.0
@onready var JumpTimer : Timer = $JumpTimer
var just_jumped: bool = false

func _ready() -> void:
	projectile = load("res://Scenes/Weapons/enemy_hat_projectile.tscn")
	super._ready()
	JumpTimer.start()
	speed = 0
	stage = 1
	if stage > 1:
		health.hp = 200


func _process(_delta: float) -> void:
	super._process(_delta)
	if is_on_floor() and !ground.enabled:
		ground.set_enabled(true)
	if just_jumped and velocity.y == 0:
		velocity.y = 0
		shoot()
	if just_jumped and ground.is_colliding():
		just_jumped = false
		can_move = true
	if speed != 0:
		sprite.play("Walking")
	else:
		sprite.play("Idle")

func _on_jump_timer_timeout() -> void:
	$JumpChecker.position.x = dir*speed
	if can_jump and $JumpChecker.is_colliding():
		jump()
	
func jump(small_jump_speed = null):
	if small_jump_speed == null:
		velocity.y = jump_speed
	else:
		velocity.y = small_jump_speed
	ground.set_enabled(false)

func pre_shoot():
	can_move = false
	jump(-200)
	just_jumped = true

func shoot():
	print('skibidi')

func _on_stage_3_timer_timeout() -> void:
	shoot()
	$stage_3_timer.stop()
	
func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.play("Idle")
