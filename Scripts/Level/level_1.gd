extends Node2D

signal on_game_over

func _ready() -> void:
	on_game_over.connect(_on_game_over)
	#CheckPointManager.player_died.connect(_on_reset_player)

func _process(delta: float) -> void:
	pass

func _on_game_over():
	print("GAME OVER")

func _on_reset_player():
	print("RESET PLAYER")
