extends Area2D

@export var sprite : AnimatedSprite2D
@export var anim_player : AnimationPlayer
@export var animation_name_left: String = "AttackAnimation_Left"
@export var animation_name_right: String = "AttackAnimation_Right"
@export var frame_hit: Array[int]
@export var damage : int
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func _ready() -> void:
	collision_shape_2d.disabled = true

func _process(_delta: float) -> void:
	if anim_player.current_animation == animation_name_left or animation_player.current_animation == animation_name_right and sprite.frame in frame_hit:
		collision_shape_2d.disabled = false
		audio_stream_player_2d.playing = true
	else:
		collision_shape_2d.disabled = true
	


func _on_area_entered(area: Area2D) -> void:
	print("Hit!")
	var hp = area.get_parent().get_node_or_null("Health")
	if hp and hp.has_method("take_damage"):
		print("Working_code :D")
		hp.take_damage(damage)
	else:
		print("Broken_code")
