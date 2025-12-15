extends PlayerState
class_name Player_Dash

var start_player_position
@export var dash_distance : float = 15
@export var dash_cooldown : Timer
@onready var canvas_layer: CanvasLayer = $"../../../CanvasLayer"
@onready var dashsfx: AudioStreamPlayer2D = $"../../Dashsfx"

func Enter():
	super()
	start_player_position = player.position.x
	if PlayerPro.projectile:
		sprite.play("Panda_Jump_No_Hat")
	else:
		sprite.play("Panda_Jump")
	if not PlayerPro.projectile_exists.is_connected(_update_anim):
		PlayerPro.projectile_exists.connect(_update_anim)
	dashsfx.playing =true
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
	AbilityData.start_cooldown(AbilityData.ability_list.Dash)

	UtilsEffect.dash_effect(player, false)
	state_transition.emit(self, "Idling")
	
func _update_anim():
	sprite.play("Panda_Jump")
