extends CharacterBody2D

class_name dragon_fly_enemy

@onready var main = get_tree().get_root().get_node("Level")

@onready var health: HP_Enemy = $Health
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var speed : int = 1
var dir : int = 1
var player: CharacterBody2D = null
@export var playerOnTop: bool = false
@export var flippedSprite: bool = false
@onready var TopCheck: RayCast2D = $TopCheck
@export var can_move: bool = true
var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_strength := 150.0
var knockback_decay := 10.0
@onready var hp_bar: ProgressBar = $ProgressBar
@export var width: float = 75
@export var height: float = 30
var previous_position: Vector2

var time := 0.0
var start_position: Vector2


var old_hp : int
func _ready() -> void:
	sprite.play("Idle")
	old_hp = health.hp
	var root = get_tree().get_current_scene()
	if root and root.has_node("Player"):
		player = root.get_node("Player")
	Engine.max_fps = 60
	hp_bar.value = health.hp
	hp_bar.max_value = health.hp
	start_position = global_position
	previous_position = global_position

func _process(_delta: float) -> void:
	
	if knockback_velocity.length() > 1:
		velocity.x = knockback_velocity.x
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay)
	else:
		if can_move:
			velocity.x = speed * dir
		else:
			velocity.x = 0
	move_and_slide()
	
	if playerOnTop:
		if TopCheck.get_collider() == null or TopCheck.get_collider().name != "Player":
			_player_not_on_top()
	elif TopCheck.is_colliding() and TopCheck.get_collider().name == "Player":
		_player_on_top()
		
	time += _delta * speed

	var x = sin(time) * width
	var y = sin(time * 2.0) * height

	global_position = start_position + Vector2(x, y)
	
	if global_position.x < previous_position.x:
		dir = -1
	elif global_position.x > previous_position.x:
		dir = 1
	_correct_sprite()
	
	previous_position = global_position

func _on_health_hp_changed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(SetShader_BlinkIntensity, 1.0, 0.0, 0.5)

	apply_knockback(player.global_position)
	hp_bar.value = health.hp
	
func SetShader_BlinkIntensity(newValue: float):
	sprite.material.set_shader_parameter("blink_intensity", newValue)

func _correct_sprite() -> void:
	if dir == 1 and $AnimatedSprite2D.scale.x == -1:
		$AnimatedSprite2D.scale.x = $AnimatedSprite2D.scale.x * -1
		flippedSprite = false
	if dir == -1 and $AnimatedSprite2D.scale.x == 1:
		$AnimatedSprite2D.scale.x = $AnimatedSprite2D.scale.x * -1
		flippedSprite = true

func apply_knockback(source_position: Vector2):
	var direction = (global_position - source_position).normalized()
	knockback_velocity = direction * knockback_strength

func _on_top_check_cooldown_timeout() -> void:
	_player_on_top()

func _player_on_top() -> void:
	player.hp.take_damage(10)
	playerOnTop = true
	$TopCheckCooldown.start()

func _player_not_on_top() -> void:
	playerOnTop = false
	$TopCheckCooldown.stop()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player.hp.take_damage(10)
