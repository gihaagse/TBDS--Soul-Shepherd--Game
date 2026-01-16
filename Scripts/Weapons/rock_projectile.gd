extends CharacterBody2D
class_name Rock_Projectile

@export var speed : float = 100.0
var sprite : AnimatedSprite2D
var direction : float
var spawnpos : Vector2
var turn_on_area : Array[int]
var turn_on_body : Array[int]
@onready var despawn: Timer = $Despawn
@onready var area_2d: Area2D = $Area2D
@onready var parry: AudioStreamPlayer2D = $Parry
var boss_stage : int

func _ready() -> void:
	sprite = $AnimatedSprite2D
	direction = -1 if sprite.flip_h else 1
	global_position = spawnpos
	for num in turn_on_area:
		area_2d.set_collision_mask_value(num, true)
	for num in turn_on_body:
		collision_mask = (1 << (num - 1)) | (1 << 0)
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
	var hp = collision.get_collider().get_node_or_null("Health")
	if hp and hp.has_method("take_damage"):
		print("Body Working_code :D")
		hp.take_damage(10)
		queue_free()
	else:
		queue_free()



func _on_despawn_timeout() -> void:
	queue_free()
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Melee"):
		parry.playing =true
		despawn.start()
		direction = -direction
		area_2d.set_collision_mask_value(2, true)
		area_2d.set_collision_mask_value(3, false)
		print("Parry " + str(area.collision_layer))
		return
	var hp = area.get_node_or_null("Health")
	if hp and hp.has_method("take_damage"):
		print("Area2D Working_code :D")
		hp.take_damage(10)
		queue_free()
	else:
		queue_free()
