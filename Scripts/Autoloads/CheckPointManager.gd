extends Node

signal respawn_player_to_checkpoint

var unlocked_checkpoints : Array = []
@export var prefer_furthest_checkpoint = true

#@onready var start_marker: Marker2D = get_tree().get_root()

@onready var unlocked_texture = preload("res://Assets/Sprites/checkpoint/Checkpoint Unlocked.png")

func _ready() -> void:
	respawn_player_to_checkpoint.connect(_respawn_player_to_checkpoint)

func checkpoint_unlocked(checkpoint: CheckPoint):
	for unlocked_cp in unlocked_checkpoints:
		if unlocked_cp["id"] == checkpoint.checkppoint_id:
			print("ALREADY UNLOCKED THIS CHECKPOINT")
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
		return Vector2.ZERO 

	var best_checkpoint = null
	var best_distance = -INF if prefer_furthest_checkpoint else INF

	for checkpoint in unlocked_checkpoints:
		var dist = player.global_position.distance_to(checkpoint["position"])

		if prefer_furthest_checkpoint and dist > best_distance:
			best_distance = dist
			best_checkpoint = checkpoint
		elif not prefer_furthest_checkpoint and dist < best_distance:
			best_distance = dist
			best_checkpoint = checkpoint

	return best_checkpoint

func _respawn_player_to_checkpoint(player: Player):
	
	var best_checkpoint = get_spawn_checkpoint(player)
	print(best_checkpoint["position"])
	player.global_position = best_checkpoint["position"] 
