extends PlayerState
class_name Player_Dash

var start_player_position
@export var dash_distance : float = 15
@export var dash_cooldown : Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var canvas_layer: CanvasLayer = $"../../../CanvasLayer"

func Enter():
	super()
	start_player_position = player.position.x
	sprite.play("Panda_Jump")
	audio_stream_player_2d.playing =true
func Exit():
	player.velocity.x = 0

func Phys_Update(_delta:float):
	if !dash_cooldown.is_stopped():
		state_transition.emit(self, "Idling")
		UtilsEffect.dash_effect(player, false)
		return
	else:
		var direction = -1 if sprite.flip_h else 1
		player.velocity.y = 0
		player.velocity.x = direction * move_speed
		UtilsEffect.dash_effect(player, true, direction)
	player.move_and_slide()
	if player.is_on_wall():
		_on_distance_travelled()
	if player.position.x >= start_player_position + dash_distance:
		_on_distance_travelled()
	if player.position.x <= start_player_position - dash_distance:
		_on_distance_travelled()

func _on_distance_travelled() -> void:
	dash_cooldown.start()
	canvas_layer.start_timer()
	UtilsEffect.dash_effect(player, false)
	state_transition.emit(self, "Idling")
