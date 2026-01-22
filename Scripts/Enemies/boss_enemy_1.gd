extends enemy

class_name boss_enemy_1

@export var dialogue: DialogueResource
@export var jump_speed: int = -125.0
@onready var JumpTimer : Timer = $JumpTimer
var just_jumped: bool = false
var just_pre_shot: bool = false

func _ready() -> void:
	projectile = load("res://Scenes/Weapons/enemy_hat_projectile.tscn")
	health.hp = 250
	super._ready()
	JumpTimer.start()
	speed = 0
	stage = 1
	health.hp_changed.connect(_boss_hit)

func _process(_delta: float) -> void:
	super._process(_delta)
	if is_on_floor() and !ground.enabled:
		ground.set_enabled(true)
	if just_jumped and velocity.y > 0 and !ground.is_colliding():
		shoot("")
		just_jumped = false
		if stage > 2:
			$stage_3_timer.start()
	if just_pre_shot:
		shoot("")
		just_pre_shot = false
		if stage > 2:
			$stage_3_timer.start()
		$in_range_shoot_timer.wait_time = 1.5
	if health.hp <= 200 and health.hp > 100 and stage != 2:
		stage = 2
	if health.hp <= 100 and stage != 3:
		stage = 3
	if ground.is_colliding() and ground.get_collider().name == "Player":
		jump()
		speed = walk_speed
	if !raycastcheckleft.is_colliding() and !raycastcheckright.is_colliding() and !ground.is_colliding():
		JumpTimer.stop()
	if velocity.x == 0 and (!sprite.is_playing() or sprite.animation == 'Walking'):
		sprite.play("Idle")
	if velocity.x != 0:
		sprite.play("Walking")

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
	if $JumpChecker.is_colliding():
		if raycastcheckleft.is_colliding() and (raycastcheckleft.get_collision_point().x - global_position.x <= -20):
			jump(-100)
			just_jumped = true
		elif raycastcheckright.is_colliding() and (raycastcheckright.get_collision_point().x - global_position.x >= 20):
			jump(-100)
			just_jumped = true
		else:
			just_pre_shot = true
	else:
		just_pre_shot = true


func shoot(attack: String):
	if global_position.x - player.global_position.x > 0:
		dir = -1
	else:
		dir = 1
	super.shoot("")

func _on_stage_3_timer_timeout() -> void:
	shoot("")
	$stage_3_timer.stop()

func _boss_hit() -> void:
	if !raycastcheckleft.is_colliding() and !raycastcheckright.is_colliding():
		pre_shoot()

func _on_npc_died():
	KeyManager.boss_death.emit()
	print("npc died script")
	if dialogue:
		#await get_tree().create_timer(1).timeout
		DialogueManager.start_dialogue(dialogue)

func _on_attack_timer_timeout() -> void:
	pass
