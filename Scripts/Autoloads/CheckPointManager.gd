extends Node

signal player_died
signal player_choice
signal died_transition

var unlocked_checkpoints : Array = []
@export var perefernce_checkpoint = true

@onready var unlocked_texture = preload("res://Assets/Sprites/checkpoint/Checkpoint Unlocked.png")
@onready var player_stored : Player =  get_tree().current_scene.get_node("Player")
var camera_main : CameraMain

var checkpoints_in_game

func _ready() -> void:
	player_choice.connect(_on_choice_made)

func register_camera(camera: CameraMain):
	camera_main = camera

func register_start(Start: Marker2D):
	unlocked_checkpoints.append({
		"id": Start.checkppoint_id,
		"position": Start.global_position,
		"node": Start
	})
	
func checkpoint_unlocked(checkpoint: CheckPoint):
	for unlocked_cp in unlocked_checkpoints:
		if unlocked_cp["id"] == checkpoint.checkppoint_id:
			return  # Already unlocked, do nothing
	
	unlocked_checkpoints.append({
		"id": checkpoint.checkppoint_id,
		"position": checkpoint.checkpoint_marker.global_position,
		"node": checkpoint
	})
	
	play_unlock_effects(checkpoint)

func play_unlock_effects(checkpoint: CheckPoint):
	var Sprite2D_node : Sprite2D = checkpoint.get_node("Sprite2D")
	if Sprite2D_node:
		Sprite2D_node.texture = unlocked_texture
	
	
func get_spawn_checkpoint(player: Player):
	if unlocked_checkpoints.is_empty():
		var start_checkpoint = checkpoints_in_game.get_node("Start")
		unlocked_checkpoints.append({
			"id": start_checkpoint.checkppoint_id,
			"position": start_checkpoint.global_position,
			"node": start_checkpoint
		})
		
		return unlocked_checkpoints[0]
	
	var best_checkpoint = null
	var closest_distance = INF
	var highest_id = -INF
	var lowest_id = INF

	for checkpoint in unlocked_checkpoints:
		if perefernce_checkpoint == "closest":
			var distance = player.global_position.distance_to(checkpoint["position"])
			if distance < closest_distance:
				closest_distance = distance
				best_checkpoint = checkpoint
		elif perefernce_checkpoint == "furthest":
			if checkpoint["id"] > highest_id:
				highest_id = checkpoint["id"]
				best_checkpoint = checkpoint
		elif perefernce_checkpoint == "begin":
			if checkpoint["id"] < lowest_id:
				lowest_id = checkpoint["id"]
				best_checkpoint = checkpoint
			
	return best_checkpoint

func _on_player_died(player: Player):
	died_transition.emit(true) # this signal sets state to died in FSM
	
	if not player_stored:
		player_stored = player
	
	Engine.time_scale = .05
	player.collision_shape_2d.disabled = true
	player_died.emit() #This signal enables the UI of checkpoint respawn

func _on_choice_made(preference: String): #This func gets called from UI script when choice is made
	perefernce_checkpoint = preference
	_respawn_player_to_checkpoint(player_stored)

func _respawn_player_to_checkpoint(player: Player):
	player.velocity.y = 0
	player.hp.hp = 100
	
	Engine.time_scale = 1
	player.collision_shape_2d.disabled = false
	
	var best_checkpoint = get_spawn_checkpoint(player)
	player.position = best_checkpoint["position"] 
	camera_main._on_respawn()
	
	died_transition.emit(false)
	
	await get_tree().create_timer(.5).timeout
