extends enemy

class_name final_boss

@export var dialogue: DialogueResource
@export var jump_speed: int = -125.0
@onready var JumpTimer : Timer = $JumpTimer
@onready var WalkTimer: Timer = $WalkTimer
@onready var ShockwaveArea : CollisionShape2D = $Shockwave/CollisionShape2D
@onready var player_hp = load("res://Scripts/Player/General/health.gd")
var just_jumped: bool = false
var random_number: int

func _ready() -> void:
	health.hp_changed.connect(_boss_hit)
	knockback_strength = 50.0
	$in_range_shoot_timer.wait_time = 1
	projectile = load("res://Scenes/Weapons/boss_enemy_projectile.tscn")
	health.hp = 200
	super._ready()
	JumpTimer.start()
	speed = 0

func _process(_delta: float) -> void:
	super._process(_delta)
	if is_on_floor() and !ground.enabled:
		ground.set_enabled(true)
	if just_jumped and velocity.y > 0 and !ground.is_colliding():
		if gravity != 2000:
			gravity = 2000
			sprite.play("Attack_Ground_Slam")
	if just_jumped and ground.is_colliding():
		just_jumped = false
		gravity = 300
		WalkTimer.start()
		shoot("ground_attack")
	if speed != 0 and ground.is_colliding() and can_move and !is_attacking:
		sprite.play("Walking")
	elif speed == 0 and ground.is_colliding() and !sprite.is_playing() and !is_attacking:
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
	sprite.play("Jumping")

func pre_shoot():
	if raycastcheckleft.is_colliding() and (raycastcheckleft.get_collision_point().x - global_position.x >= -20) and !is_attacking:
		is_attacking = true
		shoot("punch")
		can_move = false
	elif raycastcheckright.is_colliding() and (raycastcheckright.get_collision_point().x - global_position.x <= 20) and !is_attacking:
		is_attacking = true
		shoot("punch")
		can_move = false
	elif !is_attacking:
		is_attacking = true
		random_number = randi_range(1,2)
		if random_number == 1:
			can_move = false
			jump(-200)
			just_jumped = true
		else:
			can_move = false
			sprite.stop()
			sprite.play("Clap")
			$ClapTimer.start()

func shoot(attack: String):
	if attack == "clap":
		can_move = false
		ShockwaveArea.position.y = 1.97
		WalkTimer.start(1)
		if !ShockwaveArea.disabled:
			ShockwaveArea.set_disabled(true)
			await get_tree().process_frame
			ShockwaveArea.set_disabled(false)
		else:
			ShockwaveArea.set_disabled(false)
		$ShockwaveAirLeft.set_emitting(true)
		$ShockwaveAirRight.set_emitting(true)
		is_attacking = false
	elif attack == "ground_attack":
		ShockwaveArea.position.y = 8.64
		ShockwaveArea.set_disabled(false)
		$ShockwaveGroundLeft.set_emitting(true)
		$ShockwaveGroundRight.set_emitting(true)
	elif attack == "punch":
		sprite.play("Attack_punch")
		WalkTimer.start(1)
		if (raycastcheckleft.is_colliding() and (raycastcheckleft.get_collision_point().x - global_position.x >= -20)) or raycastcheckright.is_colliding() and (raycastcheckright.get_collision_point().x - global_position.x <= 20):
			await get_tree().create_timer(0,25).timeout
			player.hp.take_damage(10)
	elif attack == "projectile" and !raycastcheckleft.is_colliding() and !raycastcheckright.is_colliding():
		sprite.play("Attack_shoot")
		if global_position.x - player.global_position.x > 0:
			dir = -1
		else:
			dir = 1
		latest_hat = projectile.instantiate()
		latest_hat.sprite = sprite
		latest_hat.spawnpos = shootPoint.global_position
		if dir == 1:
			latest_hat.spawnpos.x += shotOffset
		elif dir == -1:
			latest_hat.spawnpos.x -= shotOffset
		latest_hat.spawnpos.y -= 12
		latest_hat.direction = dir
		latest_hat.boss_stage = 1
		main.add_child.call_deferred(latest_hat)
		is_attacking = false
	
func _on_animated_sprite_2d_animation_finished(anim_name: String) -> void:
	sprite.play("Idle")

func _on_walk_timer_timeout() -> void:
	can_move = true
	ShockwaveArea.set_disabled(true)
	sprite.play("Idle")
	is_attacking = false

func _on_shockwave_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player.hp.take_damage(30)
		
func _boss_hit() -> void:
	if !raycastcheckleft.is_colliding() and !raycastcheckright.is_colliding():
		shoot("projectile")
	
func _on_npc_died():
	KeyManager.boss_death.emit()
	if dialogue:
		await get_tree().create_timer(1).timeout
		DialogueManager.start_dialogue(dialogue)


func _on_clap_timer_timeout() -> void:
	shoot("clap")
