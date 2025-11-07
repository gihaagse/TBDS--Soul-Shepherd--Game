extends Node
class_name FSM

@export var initial_state : PlayerState
@export var sprite2D : AnimatedSprite2D
@export var player : CharacterBody2D
@export var weapon: Area2D
@export var shootPoint : Node2D
@export var holder : Node2D

@export var current_state : PlayerState
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is PlayerState:
			states[child.name.to_lower()] = child
			child.state_transition.connect(on_child_transition)
			
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
	
	DialogueManager.dialogue_transition.connect(func():
		on_child_transition(current_state, "Dialogue")
		)

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Phys_Update(delta)
		
func on_child_transition(state : PlayerState, new_state_name : String):
	if state != current_state:
		return
		
	var index = AbilityData.get_value_from_ability_name(new_state_name)
	#print("de index is: ", index)
	if index == null:
		return

	if index not in AbilityData.unlocked_abilities:
		return
	
	var new_state : PlayerState = states.get(new_state_name.to_lower())
	if !new_state:
		return
	

	
	if current_state:
		current_state.Exit()
		

		
	new_state.Enter()
	
	current_state = new_state
