extends Node

signal dialogue_started(dialogue_resource: DialogueResource)
signal dialogue_ended
signal text_displayed(text: String)
signal choices_displayed(choices: Array[PlayerOption])
signal dialogue_transition

var current_dialogue: DialogueResource
var current_entry: DialogueEntry
var current_line_index: int = 0
var is_dialogue_active: bool = false
#@onready var finite_state_machine: FSM = $FiniteStateMachine


var dialogue_ui: Control

func start_dialogue(dialogue_resource: DialogueResource):
	if is_dialogue_active:
		return
	
	dialogue_transition.emit()
	current_dialogue = dialogue_resource
	current_entry = dialogue_resource.dialogue_data
	current_line_index = 0
	is_dialogue_active = true
	
	dialogue_started.emit(dialogue_resource)
	display_current_line()

func display_current_line():
	if current_entry.npc_lines.size() == 0:
		show_player_choices()
		return
	
	if current_line_index < current_entry.npc_lines.size():
		var line_text = current_entry.npc_lines[current_line_index]
		text_displayed.emit(line_text)
	else:
		show_player_choices()

func next_line():
	if not is_dialogue_active:
		return
	
	current_line_index += 1
	if current_line_index < current_entry.npc_lines.size():
		display_current_line()
	else:
		show_player_choices()

func show_player_choices():
	if current_entry.player_options.size() == 0:
		end_dialogue()
		return
	
	choices_displayed.emit(current_entry.player_options)

func choose_option(option_index: int):
	if not current_entry:
		end_dialogue()
		return
	
	if not current_entry["player_options"]:
		end_dialogue()
		return

	if option_index >= current_entry.player_options.size():
		return
	
	var chosen_option = current_entry.player_options[option_index]
	
	var rewards = chosen_option.get("rewards")
	if rewards != null and rewards is Dictionary and rewards.size() > 0:
		process_rewards(rewards)

	if chosen_option.npc_response:
		current_entry = chosen_option.npc_response
		current_line_index = 0
		display_current_line()
	else:
		end_dialogue()

func process_rewards(rewards: Dictionary):
	for reward_type in rewards:
		print("Reward given: ", reward_type, " = ", rewards[reward_type])

func end_dialogue():
	dialogue_ended.emit()
	is_dialogue_active = false
	current_dialogue = null
	current_entry = null
	current_line_index = 0
