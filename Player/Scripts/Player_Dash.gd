extends PlayerState
class_name Player_Dash

var start_player_position
@export var dash_distance : float = 15
@onready var timer: Timer = $Timer

func Enter():
	super()
	start_player_position = player.position.x
	if !timer.is_stopped():
		state_transition.emit(self, "Idling")
		return
	else:
		sprite.play("Jump")
func Exit():
	player.velocity.x = 0

func Phys_Update(_delta:float):
	if !timer.is_stopped():
		state_transition.emit(self, "Idling")
		return
	else:
		var direction = -1 if sprite.flip_h else 1
		player.velocity.y = 0
		player.velocity.x = direction * walk_speed
	player.move_and_slide()
	if player.is_on_wall():
		_on_distance_travelled()
	if player.position.x >= start_player_position + dash_distance:
		_on_distance_travelled()
	if player.position.x <= start_player_position - dash_distance:
		_on_distance_travelled()

func _on_distance_travelled() -> void:
	timer.start()
	state_transition.emit(self, "Idling")
