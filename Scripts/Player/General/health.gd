extends Node
class_name HP
@export var hp = 100
@onready var timer: Timer = $Timer

@onready var player_death_sfx: AudioStreamPlayer2D = $PlayerDeathSfx
@onready var bone_break_sfx: AudioStreamPlayer2D = $BoneBreakSfx

@onready var player_animated_sprite = get_parent().get_node("AnimatedSprite2D")
@onready var player_shader_material = player_animated_sprite.material as ShaderMaterial

signal hp_changed

enum DamageType { NORMAL, FALL, SWORD, PROJECTILE}

func take_damage(dmg : int, damage_type: DamageType = DamageType.NORMAL):
	UtilsEffect.damage_effect(player_shader_material)
	
	hp -= dmg
	_play_damage_sfx(damage_type)
	hp_changed.emit()
	if get_parent().is_in_group("Player") and hp <= 0:
		var player = get_parent()
		var current_state = player.get_node("FiniteStateMachine")._get_current_state()
		if current_state != player.get_node("FiniteStateMachine").get_node("Died"):
			CheckPointManager._on_player_died(player)
		#Engine.time_scale = .2
		#timer.start()
	elif(hp <= 0):
		get_parent().queue_free()

func _on_player_player_hit(dmg) -> void:
	take_damage(dmg)

func _play_damage_sfx(damage_type: DamageType) -> void:
	match damage_type:
		DamageType.NORMAL:
			player_death_sfx.play()
		DamageType.FALL:
			bone_break_sfx.play()
		_:
			player_death_sfx.play()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	#get_tree().reload_current_scene()
	#if get_parent().is_in_group("Player"):
		#var player : Player = get_parent()
		#CheckPointManager.respawn_player_to_checkpoint.emit(player)
