extends enemy

class_name boss_enemy_1

@export var jump_speed: int = -125.0
@onready var JumpTimer : Timer = $JumpTimer
var just_jumped: bool = false

func _ready() -> void:
	projectile = load("res://Scenes/Weapons/enemy_hat_projectile.tscn")
	super._ready()
	JumpTimer.start()
	speed = 0
	stage = 2
	if stage > 1:
		health.hp = 200


func _process(_delta: float) -> void:
	super._process(_delta)
	if is_on_floor() and !ground.enabled:
		ground.set_enabled(true)
	if just_jumped and velocity.y == 0:
		shoot()
		just_jumped = false
		if stage > 2:
			$stage_3_timer.start()

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
	jump(-100)
	just_jumped = true

func shoot():
	super.shoot()


func _on_stage_3_timer_timeout() -> void:
	shoot()
	$stage_3_timer.stop()
