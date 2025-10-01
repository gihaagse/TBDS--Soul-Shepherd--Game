extends CharacterBody2D
class_name Projectile

@export var speed : float = 100.0
@export var sprite : AnimatedSprite2D
var direction : float
var spawnpos : Vector2
var turn_on : int
@onready var despawn: Timer = $Despawn
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	direction = -1 if sprite.flip_h else 1
	global_position = spawnpos
	area_2d.set_collision_mask_value(turn_on, true)
	despawn.start()
	
func _physics_process(_delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta.
	if direction:
		velocity.x = direction * speed

	var collision = move_and_collide(velocity * _delta)
	if collision:
		_on_body_entered(collision)

func _on_body_entered(collision: KinematicCollision2D) -> void:
	print("Body Hit!")
	var hp = collision.get_collider().get_node_or_null("Health")
	if hp and hp.has_method("take_damage"):
		print("Body Working_code :D")
		hp.take_damage(10)
		queue_free()
	else:
		print("Body Broken_code")
		queue_free()



func _on_despawn_timeout() -> void:
	queue_free()
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Melee"):
		despawn.start()
		direction = -direction
		area_2d.set_collision_mask_value(2, true)
		print("Parry")
		return
	print("Area2D Hit!")
	var hp = area.get_node_or_null("Health")
	if hp and hp.has_method("take_damage"):
		print("Area2D Working_code :D")
		hp.take_damage(10)
		queue_free()
	else:
		print("Area2D Broken_code")
		queue_free()
