extends CharacterBody2D

class_name enemy

@onready var main = get_tree().get_root().get_node("Level")
@onready var projectile = load("res://Scenes/Weapons/projectile.tscn")
@export var shootPoint : Node2D
@export var groundPosOffset : float = 10

@onready var health: HP_Enemy = $Health
@onready var label: Label = $Label
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@export var walk_speed : int = 50
@export var sprint_speed : int = 70
var speed : int = 0
@export var dir : int = 1
var player: CharacterBody2D = null
@export var playerInRange: bool = false
@export var playerOnTop: bool = false
@export var flippedSprite: bool = false
@export var shotOffset: int = 15
@onready var ground: RayCast2D = $GroundCheck
@onready var TopCheck: RayCast2D = $TopCheck
@onready var gravity: float = 300.0
@export var can_move: bool = true
@onready var raycastcheckright: RayCast2D = $RayCast2DRight
@onready var raycastcheckleft: RayCast2D = $RayCast2DLeft
var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_strength := 150.0
var knockback_decay := 10.0
@export var can_jump: bool
var projectile_index_number: int
var latest_hat : Node
@onready var hp_bar: ProgressBar = $ProgressBar
var stage: int = 0


var old_hp : int
func _ready() -> void:
	sprite.play("Idle")
	old_hp = health.hp
	var root = get_tree().get_current_scene()
	if root and root.has_node("Player"):
		player = root.get_node("Player")
	Engine.max_fps = 60
	speed = walk_speed
	_on_animated_sprite_2d_animation_finished("")
	$Label.set_text("HP: " + str(health.hp))
	hp_bar.max_value = health.hp
	hp_bar.value = health.hp


func _process(_delta: float) -> void:
	if !can_move:
		speed = 0
	_correct_sprite()
	ground.position.x = groundPosOffset if dir > 0 else groundPosOffset * -1
		
	if not is_on_floor():
		velocity.y += gravity * _delta
	else:
		#velocity.y = 0
		pass

	
	if old_hp != health.hp:
		label.text = "HP: " + str(health.hp)
		old_hp = health.hp
		
	if (is_on_wall() or (!ground.is_colliding() and ground.enabled)) and can_move:
		dir = dir * -1

	if knockback_velocity.length() > 1:
		velocity.x = knockback_velocity.x
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay)
	else:
		if can_move:
			velocity.x = speed * dir
		else:
			velocity.x = 0
	move_and_slide()
	
	if playerInRange:
		if raycastcheckleft.get_collider() == null and raycastcheckright.get_collider() == null:
			_on_area_2d_body_shape_exited()
		elif (raycastcheckleft.get_collider() == null or raycastcheckleft.get_collider().name != "Player") and (raycastcheckright.get_collider().name != "Player" or raycastcheckright.get_collider() == null):
			_on_area_2d_body_shape_exited()
		elif raycastcheckleft.is_colliding():
			dir = -1
		elif raycastcheckright.is_colliding():
			dir = 1
	elif raycastcheckright.is_colliding() and raycastcheckright.get_collider().name == "Player" and can_move:
		dir = 1
		flippedSprite = false
		ground.position.x = groundPosOffset
		_on_area_2d_body_shape_entered()
	elif raycastcheckleft.is_colliding() and raycastcheckleft.get_collider().name == "Player" and can_move:
		dir = -1
		flippedSprite = false
		ground.position.x = groundPosOffset
		_on_area_2d_body_shape_entered()
		
	if playerOnTop:
		if TopCheck.get_collider() == null or TopCheck.get_collider().name != "Player":
			_player_not_on_top()
	elif TopCheck.is_colliding() and TopCheck.get_collider().name == "Player":
		_player_on_top()

func _on_health_hp_changed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(SetShader_BlinkIntensity, 1.0, 0.0, 0.5)
	
	gpu_particles_2d.restart()
	gpu_particles_2d.emitting = true
	apply_knockback(player.global_position)
	hp_bar.value = health.hp

func pre_shoot():
	shoot("")

func shoot(attack: String):
	speed = 0
	sprite.play("Attack_shoot")
	latest_hat = projectile.instantiate()
	#latest_hat.sprite = spritem
	latest_hat.spawnpos = shootPoint.global_position
	if dir == 1:
		latest_hat.spawnpos.x += shotOffset
	elif dir == -1:
		latest_hat.spawnpos.x -= shotOffset
	latest_hat.direction = dir
	latest_hat.boss_stage = stage
	main.add_child.call_deferred(latest_hat)
	
func SetShader_BlinkIntensity(newValue: float):
	sprite.material.set_shader_parameter("blink_intensity", newValue)

func _on_timer_timeout() -> void:
	pre_shoot()

func _on_area_2d_body_shape_entered() -> void:
	playerInRange = true
	speed = sprint_speed
	can_jump = false
	$in_range_shoot_timer.start()

func _on_area_2d_body_shape_exited() -> void:
	playerInRange = false
	speed = walk_speed
	can_jump = true
	$in_range_shoot_timer.stop()

func _correct_sprite() -> void:
	if is_on_floor():
		if dir == 1 and $AnimatedSprite2D.scale.x == -1:
			$AnimatedSprite2D.scale.x = $AnimatedSprite2D.scale.x * -1
			flippedSprite = false
		if dir == -1 and $AnimatedSprite2D.scale.x == 1:
			$AnimatedSprite2D.scale.x = $AnimatedSprite2D.scale.x * -1
			flippedSprite = true

func _on_animated_sprite_2d_animation_finished(anim_name: String) -> void:
	if speed != 0:
		sprite.play("Walking")
	else:
		sprite.play("Idle")

func apply_knockback(source_position: Vector2):
	var direction = (global_position - source_position).normalized()
	knockback_velocity = direction * knockback_strength

func _on_top_check_cooldown_timeout() -> void:
	_player_on_top()

func _player_on_top() -> void:
	player.hp.take_damage(30)
	playerOnTop = true
	$TopCheckCooldown.start()

func _player_not_on_top() -> void:
	playerOnTop = false
	$TopCheckCooldown.stop()
