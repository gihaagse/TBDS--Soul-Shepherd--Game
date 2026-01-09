extends Node2D

@export var hover_radius: float = 30.0
@export var hover_speed: float = 2.0
@export var bob_amplitude: float = 5.0
@export var bob_speed: float = 3.0

var player: Node2D
var angle: float = 0.0
var original_z_index: int

func _ready():
	original_z_index = z_index

func add_key_to_player(body: Node2D):
	if body.is_in_group("player"):
		player = body
		player.add_child(self)
		z_index = player.z_index + 1
		global_position = player.global_position

func _process(delta):
	if player:
		angle += hover_speed * delta
		var offset = Vector2(
			cos(angle) * hover_radius,
			sin(angle) * hover_radius + sin(angle * bob_speed) * bob_amplitude
		)
		global_position = player.global_position + offset
