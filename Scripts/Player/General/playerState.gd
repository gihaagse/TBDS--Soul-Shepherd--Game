extends Node
class_name PlayerState

signal state_transition

static var jumps_left: int = 1
static var custom_gravity : Vector2 = Vector2(0,980)
static var in_gliding: bool = false
static var last_character_orientation: int = 0

var player : CharacterBody2D
var sprite : AnimatedSprite2D
var weapon: Area2D
var shootPoint : Node2D
var holder : Node2D
var slots : Array[Node2D]
var level_camera: Camera2D
var walking_dust_particle: CPUParticles2D
var jump_particle: GPUParticles2D
var run_particle_timer : float

@export var max_airglide_velocity: int  = 180
@export var run_particle_offset := 0.25
@export var move_speed : int = 120
@export var jump_force : int = 300
@export var brake_force : int = 20
@export var jumpsfx: AudioStreamPlayer2D

@export_group("bools")
@export var can_move : bool = true
@export var can_jump : bool = true
@export var in_anim : bool = false
@export var is_gravity : bool = true
@export var can_shoot : bool = false
@export var airsStrafe : int = 20

func _ready() -> void:
	level_camera = get_tree().current_scene.get_node("Camera2D")

func Enter():
	var parent = get_parent()
	sprite = parent.sprite2D
	player = parent.player
	weapon = parent.weapon
	shootPoint = parent.shootPoint
	holder = parent.holder
	walking_dust_particle = player.get_node("WalkingDustParticle")
	jump_particle = player.get_node("JumpParticle")
	for child in holder.get_children():
		slots.append(child)
	return
	
func Exit():
	pass
	
func Update(_delta:float):
	pass
	
func Phys_Update(_delta:float):
	pass

func movement(_delta:float):
	if player.is_on_floor():
		custom_gravity = Vector2(0,980)
	
	run_particle_timer += _delta
	if Input.is_action_just_pressed("Jump") and player.is_on_floor() and can_jump:
		jumpsfx.playing = true
		player.velocity.y = -jump_force
		UtilsEffect.stretch(sprite, .2, .175)
		jump_particle.emitting = false
		jump_particle.restart()
		jump_particle.emitting = true
	elif is_gravity:
		player.velocity += custom_gravity * _delta
		if player.velocity.length() >= max_airglide_velocity and in_gliding:
			player.velocity = player.velocity.normalized() * max_airglide_velocity
	

	var direction := Input.get_axis("Left", "Right")
	if direction != 0:
		last_character_orientation = direction
	
	if !in_anim and last_character_orientation:
		sprite.flip_h = last_character_orientation < 0
		weapon.position.x = -14 if last_character_orientation < 0 else 14
		shootPoint.position.x = -14 if last_character_orientation < 0 else 14
	
	UtilsEffect.lean_run(sprite, _delta, direction)
	if player.is_on_floor_only() and direction:
		if run_particle_timer >= run_particle_offset:
			walking_dust_particle.direction = Vector2(-direction, walking_dust_particle.direction.y)
			walking_dust_particle.emitting = true
	else:
		walking_dust_particle.emitting = false
		run_particle_timer = 0
	
	if not player.is_on_floor() and direction and can_move:
		player.velocity.x = move_toward(player.velocity.x, direction * move_speed, airsStrafe)
	elif direction and can_move:
		player.velocity.x = direction * move_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, brake_force)

	player.move_and_slide()
	
func get_item_by_name(node_name: String, array: Array[Node2D]):
	var found = array.filter(func(n): return n.name == node_name)
	if found.size() > 0:
		return found[0]
