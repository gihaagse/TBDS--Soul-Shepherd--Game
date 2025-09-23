extends Node

var character_states = {}  # Dictionary: character_node -> StateHandler
var player_character = null

func add_character(character):
	var state_handler = StateHandler.new(character)
	character_states[character] = state_handler
	
	print("Registered character: ", character.name)
	
	if character.is_in_group("player"):
		player_character = character
		state_handler.SetState("STUNNED", true)
		print("Player character set: ", character.name)

func remove_character(character):
	if character in character_states:
		character_states.erase(character)
		if character == player_character:
			player_character = null
		print("Removed character: ", character.name)

func ProcessPlayerAction(action_data: Dictionary):
	if player_character and player_character in character_states:
		var state_handler = character_states[player_character]
		if state_handler.can_perform_action(action_data["action"]):
			execute_action(player_character, action_data)
		else:
			print("Player action blocked: ", action_data["action"], " in state: ", state_handler.GetCurrentState())

func ProcessCharacterAction(character, action_data: Dictionary):
	if character in character_states:
		var state_handler = character_states[character]
		if state_handler.can_perform_action(action_data["action"]):
			execute_action(player_character, action_data)
		else:
			print("Character action blocked: ", action_data["action"], " for ", character.name)

func execute_action(character, action_data: Dictionary):
	var action: String = action_data["action"]
	
	if character.has_method(action):
		if action == "MOVING":
			var direction: int = action_data["direction"]
			if not direction: return
			
			character.MOVING(direction)
		else:
			print("HAS FUNC FOR ACTION ", action)
			character.call(action)

func GetStateHandler(character):
	return character_states.get(character, null)

func GetAllCharacters():
	return character_states.keys()

func debug_print_states():
	print("=== Character States Debug ===")
	for character in character_states:
		var state = character_states[character].GetCurrentState()
		print(character.name, ": ", state)
	print("Player: ", player_character.name if player_character else "None")
