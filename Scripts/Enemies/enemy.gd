extends CharacterBody2D

class_name enemy

@onready var main = get_tree().get_root().get_node("Level")
@onready var projectile = load("res://Scenes/Weapons/projectile.tscn")
@export var shootPoint : Node2D
@export var groundPosOffset : float = 10

@onready var health: HP = $Health
@onready var label: Label = $Label
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@export var speed : int = 40
@export var dir : int = 1
var player: CharacterBody2D = null
@export var playerInRange: bool = false
@export var flippedSprite: bool = false
@export var shotOffset: int = 15
@onready var ground: RayCast2D = $GroundCheck
@onready var gravity: float = 300.0
@export var can_move: bool = true
@onready var raycastcheckright: RayCast2D = $RayCast2DRight
@onready var raycastcheckleft: RayCast2D = $RayCast2DLeft
var ground_collider


var old_hp : int
func _ready() -> void:
	sprite.play("Idle")
	old_hp = health.hp
	var root = get_tree().get_current_scene()
	if root and root.has_node("Player"):
		player = root.get_node("Player")
	Engine.max_fps = 60

func _process(_delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * _delta
	else:
		velocity.y = 0
	
	if old_hp != health.hp:
		label.text = "HP: " + str(health.hp)
		old_hp = health.hp
		
	if (is_on_wall() or !ground.is_colliding()) and can_move:
		dir = dir * -1
		ground.position.x = groundPosOffset if dir > 0 else groundPosOffset * -1
		_correct_sprite()

	if can_move:
		position.x += speed * dir * _delta
	if sprite.get_animation() != "Walking" and sprite.get_animation() != "Attack_shoot" and can_move:
		sprite.play("Walking")
	move_and_slide()
	
	if playerInRange:
		if raycastcheckleft.get_collider() == null and raycastcheckright.get_collider() == null:
			_on_area_2d_body_shape_exited()
		elif (raycastcheckleft.get_collider() == null or raycastcheckleft.get_collider().name != "Player") and (raycastcheckright.get_collider().name != "Player" or raycastcheckright.get_collider() == null):
			_on_area_2d_body_shape_exited()
	elif raycastcheckright.is_colliding() and raycastcheckright.get_collider().name == "Player" and can_move:
		dir = 1
		flippedSprite = false
		ground.position.x = groundPosOffset
		_correct_sprite()
		_on_area_2d_body_shape_entered()
	elif raycastcheckleft.is_colliding() and raycastcheckleft.get_collider().name == "Player" and can_move:
		dir = -1
		flippedSprite = false
		ground.position.x = groundPosOffset
		_correct_sprite()
		_on_area_2d_body_shape_entered()
	

func _on_health_hp_changed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(SetShader_BlinkIntensity, 1.0, 0.0, 0.5)
	
	gpu_particles_2d.restart()
	gpu_particles_2d.emitting = true

func shoot():
	sprite.play("Attack_shoot")
	var instance = projectile.instantiate()
	instance.sprite = sprite
	instance.spawnpos = shootPoint.global_position
	if dir == 1:
		instance.spawnpos.x += shotOffset
	elif dir == -1:
		instance.spawnpos.x -= shotOffset
		instance.speed = instance.speed * -1
	main.add_child.call_deferred(instance)
	
func SetShader_BlinkIntensity(newValue: float):
	sprite.material.set_shader_parameter("blink_intensity", newValue)

func _on_timer_timeout() -> void:
	shoot()

func _on_area_2d_body_shape_entered() -> void:
	playerInRange = true
	speed = 60
	$in_range_shoot_timer.start()

func _on_area_2d_body_shape_exited() -> void:
	playerInRange = false
	speed = 40
	$in_range_shoot_timer.stop()

func _correct_sprite() -> void:
	if dir == 1 and $AnimatedSprite2D.scale.x == -1:
		$AnimatedSprite2D.scale.x = $AnimatedSprite2D.scale.x * -1
		flippedSprite = false
	if dir == -1 and $AnimatedSprite2D.scale.x == 1:
		$AnimatedSprite2D.scale.x = $AnimatedSprite2D.scale.x * -1
		flippedSprite = true


func _on_animated_sprite_2d_animation_finished() -> void:
	if can_move:
		sprite.play("Walking")
	else:
		sprite.play("Idle")
