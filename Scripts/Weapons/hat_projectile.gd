extends CharacterBody2D
class_name Projectile

@export var speed : float = 100.0
@export var sprite : AnimatedSprite2D
var player : Player
var direction : float
var spawnpos : Vector2
var turn_on_area : Array[int]
var turn_on_body : Array[int]
var retrn : bool = false
@onready var despawn: Timer = $Despawn
@onready var area_2d: Area2D = $Area2D
@onready var parry: AudioStreamPlayer2D = $Parry

func _ready() -> void:
	direction = -1 if sprite.flip_h else 1
	global_position = spawnpos
	for num in turn_on_area:
		area_2d.set_collision_mask_value(num, true)
	for num in turn_on_body:
		collision_mask = (1 << (num - 1)) | (1 << 0)
	despawn.start()
	
func _physics_process(_delta: float) -> void:
	if direction and not retrn:
		velocity.x = direction * speed
	if self.position.distance_to(player.position) > 150:
		retrn = true
		collision_mask = (0<<0) | (1<<8)
		despawn.stop()
	if retrn:
		velocity = self.position.direction_to(player.position) * speed
	if retrn and self.position.distance_to(player.position) < 20:
		queue_free()

	var collision = move_and_collide(velocity * _delta)
	if collision:
		_on_body_entered(collision)

func _on_body_entered(collision: KinematicCollision2D) -> void:
	var coll = collision.get_collider()
	var hp = coll.get_node_or_null("Health")
	print("bop ")
	if hp and hp.has_method("take_damage"):
		print("Body Working_code :D")
		hp.take_damage(10)
		retrn = true
		collision_mask = (0<<0) | (0<<2) | (0<<8)
		despawn.stop()
	else:
		retrn = true
		collision_mask = (0<<0) | (0<<2)
		despawn.stop()



func _on_despawn_timeout() -> void:
	queue_free()
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	#if area.is_in_group("Melee"):
		#parry.playing =true
		#despawn.start()
		#retrn = false
		#direction = -direction
		#area_2d.set_collision_mask_value(2, true)
		#area_2d.set_collision_mask_value(3, false)
		#collision_mask = (1<<0) | (1<<2)
		#print("Parry " + str(area.collision_layer))
		#return
	#var hp = area.get_node_or_null("Health")
	#if hp and hp.has_method("take_damage"):
		#print("Area2D Working_code :D")
		#hp.take_damage(10)
		#despawn.start()
		#direction = -direction
	#else:
		#despawn.start()
		#direction = -direction
	pass
