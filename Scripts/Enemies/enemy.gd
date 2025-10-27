extends CharacterBody2D

@onready var main = get_tree().get_root().get_node("Level")
@onready var projectile = load("res://Scenes/Weapons/projectile.tscn")
@export var shootPoint : Node2D

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
var ground_collider


var old_hp : int
func _ready() -> void:
	old_hp = health.hp
	var root = get_tree().get_current_scene()
	if root and root.has_node("Player"):
		player = root.get_node("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * _delta
	else:
		velocity.y = 0
	
	if old_hp != health.hp:
		label.text = "HP: " + str(health.hp)
		old_hp = health.hp
		
	if is_on_wall() or !ground.is_colliding():
		dir = dir * -1
		_correct_sprite()
		ground.position.x = ground.position.x * dir

	position.x += speed * dir * _delta
	move_and_slide()
	if playerInRange:
		if (player.position.x - position.x) > 0:
			dir = 1
			flippedSprite = false
			_correct_sprite()
		elif (player.position.x - position.x) < 0:
			dir = -1
			flippedSprite = true
			_correct_sprite()


func _on_health_hp_changed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(SetShader_BlinkIntensity, 1.0, 0.0, 0.5)
	
	gpu_particles_2d.restart()
	gpu_particles_2d.emitting = true

func shoot():
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

func _on_area_2d_body_shape_entered(body_rid: RID, body: CharacterBody2D, body_shape_index: int, local_shape_index: int) -> void:
	playerInRange = true
	speed = 60
	$in_range_shoot_timer.start()

func _on_area_2d_body_shape_exited(body_rid: RID, body: CharacterBody2D, body_shape_index: int, local_shape_index: int) -> void:
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
