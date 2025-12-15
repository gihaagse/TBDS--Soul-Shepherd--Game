extends CharacterBody2D
class_name Enemy_projectile

@export var speed : float = 100.0
@export var sprite : AnimatedSprite2D
var direction : float
var spawnpos : Vector2
var turn_on_area : Array[int]
var turn_on_body : Array[int]
@onready var despawn: Timer = $Despawn
@onready var area_2d: Area2D = $Area2D
@onready var parry: AudioStreamPlayer2D = $Parry
var start_pos: Vector2
var end_pos: Vector2
var control_point: Vector2
@export var control_point_offset := Vector2(50, -25)
var t := 0.0
@export var duration := 1.5
@onready var enemy_hat = load("res://Scenes/Weapons/enemy_hat_projectile.tscn")
@onready var main = get_tree().get_root().get_node("Level")
var is_first: bool = true
var first_time: bool = true

func _ready() -> void:
	if is_first:
		$HatSplitTimer.start()
	else:
		despawn.wait_time -= 1
	if direction == -1:
		sprite.flip_h
	global_position = spawnpos
	for num in turn_on_area:
		area_2d.set_collision_mask_value(num, true)
	for num in turn_on_body:
		collision_mask = (1 << (num - 1)) | (1 << 0)
	despawn.start()
	
func _physics_process(_delta: float) -> void:
	velocity.x = direction * speed
	if ($HatSplitTimer.is_stopped() or !is_first) and start_pos == Vector2(0.0, 0.0):#time_left == 1.0:
		t = 0.0
		start_pos = global_position
		#start_pos.x = start_pos.x + (100*direction)
		end_pos = start_pos
		end_pos.x = end_pos.x + (100*direction)
		if is_first:
			control_point_offset.y = control_point_offset.y * -1
		control_point_offset.x = control_point_offset.x * direction
		control_point = start_pos + control_point_offset
	var collision = move_and_collide(velocity * _delta)
	if collision:
		_on_body_entered(collision)
	
	t += _delta / duration
	t = clamp(t, 0, 1)

	if $HatSplitTimer.is_stopped() and first_time:
		global_position = bezier(start_pos, control_point, end_pos, t)
	
	if global_position == end_pos:
		first_time = false
	
	#print(global_position)

func _on_body_entered(collision: KinematicCollision2D) -> void:
	var coll = collision.get_collider()
	var hp = coll.get_node_or_null("Health")
	if hp and hp.has_method("take_damage") and coll.collision_layer & (1<<0):
		print("Body Working_code :D")
		hp.take_damage(10)
		collision_mask = (0<<0) | (1<<2)
		queue_free()
		direction = -direction
	else:
		queue_free()
	
func bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
	return ((1 - t) * (1 - t) * p0) + (2 * (1 - t) * t * p1) + (t * t * p2)

func _on_despawn_timeout() -> void:
	queue_free()
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Melee"):
		print("Melee")
		parry.playing =true
		despawn.start()
		direction = -direction
		area_2d.set_collision_mask_value(2, true)
		area_2d.set_collision_mask_value(3, false)
		collision_mask = (1<<0) | (1<<2)
		print("Parry " + str(area.collision_layer))
		return
	var hp = area.get_node_or_null("Health")
	if hp and hp.has_method("take_damage"):
		print("Area2D Working_code :D")
		hp.take_damage(10)
		despawn.start()
		direction = -direction
	else:
		despawn.start()
		direction = -direction
		
func _on_hat_split_timer_timeout() -> void:
	print("skibedi")
	var instance = enemy_hat.instantiate()
	instance.sprite = sprite
	instance.spawnpos = global_position
	instance.spawnpos.y = instance.spawnpos.y - 10
	instance.velocity = velocity
	instance.direction = direction
	instance.is_first = false
	main.add_child.call_deferred(instance)
	await get_tree().process_frame
	$HatSplitTimer.stop()
