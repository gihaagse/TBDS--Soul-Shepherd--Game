extends Node

func _ready():
	print("InputHandler loaded and ready!")

func _input(event):
	if event.is_action_pressed("JUMPING"):
		CentralManager.ProcessPlayerAction({
			"action": "JUMPING"
		})
	
	if event.is_action_pressed("RUNNING"):
		var players = get_tree().get_nodes_in_group("player")
		var player = players[0] if players.size() > 0 else null
		
		if player.has_method("RUNNING"):
			player.RUNNING()

	if event.is_action_pressed("LEFT") or event.is_action_pressed("RIGHT"):
		_handle_movement()
	elif event.is_action_released("LEFT") or event.is_action_released("RIGHT"):
		_handle_movement()

func _handle_movement():
	var left_pressed = Input.is_action_pressed("LEFT")
	var right_pressed = Input.is_action_pressed("RIGHT")
	
	if left_pressed and right_pressed:
		print("BOTH KEYS PRESSED - IDLE")
		CentralManager.ProcessPlayerAction({
			"action": "IDLE"
		})
	elif left_pressed and not right_pressed:
		CentralManager.ProcessPlayerAction({
			"action": "MOVING",
			"direction": -1
		})
	elif right_pressed and not left_pressed:
		CentralManager.ProcessPlayerAction({
			"action": "MOVING",
			"direction": 1
		})
	else:
		CentralManager.ProcessPlayerAction({
			"action": "IDLE"
		})
