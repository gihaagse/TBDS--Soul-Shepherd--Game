extends Area2D

@export var sprite : AnimatedSprite2D
@export var animation_name: String
@export var frame_hit: Array[int]
@export var damage : int
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	collision_shape_2d.disabled = true

func _process(_delta: float) -> void:
	if sprite.animation == animation_name and sprite.frame in frame_hit:
		collision_shape_2d.disabled = false
		audio_stream_player_2d.playing = true
	else:
		collision_shape_2d.disabled = true
	


func _on_area_entered(area: Area2D) -> void:
	print("Hit!")
	var hp = area.get_node_or_null("Health")
	if hp and hp.has_method("take_damage"):
		print("Working_code :D")
		hp.take_damage(damage)
	else:
		print("Broken_code")
