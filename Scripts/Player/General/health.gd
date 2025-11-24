extends Node
class_name HP
@export var hp = 50
@onready var timer: Timer = $Timer
@onready var player_death: AudioStreamPlayer2D = $PlayerDeath

signal hp_changed

func take_damage(dmg : int):
	hp -= dmg
	hp_changed.emit()
	if get_parent().is_in_group("Player") and hp <= 0:
		var player = get_parent()
		var current_state = player.get_node("FiniteStateMachine")._get_current_state()
		if current_state != player.get_node("FiniteStateMachine").get_node("Died"):
			CheckPointManager._on_player_died(player)
		#player_death.playing =true
		#Engine.time_scale = .2
		#timer.start()
	elif(hp <= 0):
		get_parent().queue_free()

func _on_player_player_hit(dmg) -> void:
	take_damage(dmg)

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	#get_tree().reload_current_scene()
	#if get_parent().is_in_group("Player"):
		#var player : Player = get_parent()
		#CheckPointManager.respawn_player_to_checkpoint.emit(player)
