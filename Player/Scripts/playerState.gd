extends Node
class_name PlayerState

signal state_transition

var player : CharacterBody2D
var sprite : AnimatedSprite2D
var weapon: Area2D
var shootPoint : Node2D
var holder : Node2D
var slots : Array[Node2D]
@export var move_speed : int = 120
@export var jump_force : int = 300
@export var brake_force : int = 20
@export var can_move : bool = true
@export var can_jump : bool = true
@export var in_anim : bool = false
@export var is_gravity : bool = true
@export var can_shoot : bool = false
@export var airsStrafe : int = 20
@export var jumpsfx: AudioStreamPlayer2D

func Enter():
	var parent = get_parent()
	sprite = parent.sprite2D
	player = parent.player
	weapon = parent.weapon
	shootPoint = parent.shootPoint
	holder = parent.holder
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
	if Input.is_action_just_pressed("Jump") and player.is_on_floor() and can_jump:
		jumpsfx.playing = true
		player.velocity.y = -jump_force
	elif is_gravity:
		player.velocity += player.get_gravity() * _delta
		
	var direction := Input.get_axis("Left", "Right")
	if !in_anim and direction:
		sprite.flip_h = direction < 0
		weapon.position.x = -14 if direction < 0 else 14
		shootPoint.position.x = -14 if direction < 0 else 14
	
	
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
