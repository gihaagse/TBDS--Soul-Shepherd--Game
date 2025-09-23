extends Resource
class_name StateHandler

var active_states: Dictionary = {}
var current_state: String
var config: StateConfig = preload("res://Src/scripts/config/new_resource.tres")

var base_walkspeed : int
var base_runspeed : int
var base_jumppower : int

var speed_modifier : float = 1

func _ready():
	pass

func _init(character) -> void:
	current_state = "IDLE"
	active_states["IDLE"] = true
	
	base_walkspeed = character.BASE_WALKSPEED
	

func SetState(new_state: String, enabled: bool):
	if not config.priority.get(new_state):
		return
	
	if enabled:
		active_states[new_state] = true
	else:
		ResetStates([new_state])
	
	_update_current_state()

func _update_current_state():
	var highest_priority = -1
	var new_current_state = "IDLE"
	
	for state in active_states.keys():
		var priority = config.priority.get(state, 0)
		if priority > highest_priority:
			highest_priority = priority
			new_current_state = state
	
	current_state = new_current_state
	print("Current state updated to: ", current_state)

func GetCurrentState() -> String:
	return current_state

func ResetStates(states_to_remove: Array):
	for state in states_to_remove:
		if active_states.has(state):
			active_states.erase(state)
			print("Removed state: ", state)    

	_update_current_state()

func get_behaviour(state_name: String) -> Dictionary:
	return config.behaviours.get(state_name, {})

func can_perform_action(action: String) -> bool:
	var behaviour = get_behaviour(current_state)
	
	match action:
		"JUMPING":
			return behaviour.get("canJump", false)
		"MOVING":
			return behaviour.get("canMove", false)
		"ATTACKING":
			return behaviour.get("canAttack", false)
		"PARRYING":
			return behaviour.get("canParry", false)
		"DASHING":
			return behaviour.get("canDash", false)
		"IDLE":
			return true 
		_:
			return false

func get_speed_multiplier() -> float:
	var behaviour = get_behaviour(current_state)
	return behaviour.get("walkSpeedMultiplier", 1.0)

func get_jump_multiplier() -> float:
	var behaviour = get_behaviour(current_state)
	return behaviour.get("jumpPowerMultiplier", 1.0)

# Debug functie
func debug_current_abilities() -> Dictionary:
	var behaviour = get_behaviour(current_state)
	return {
		"state": current_state,
		"canAttack": behaviour.get("canAttack", false),
		"canParry": behaviour.get("canParry", false),
		"canJump": behaviour.get("canJump", false),
		"canWalk": behaviour.get("canWalk", false),
		"canRun": behaviour.get("canRun", false),
		"canDash": behaviour.get("canDash", false),
		"walkSpeed": behaviour.get("walkSpeedMultiplier", 1.0),
		"jumpPower": behaviour.get("jumpPowerMultiplier", 1.0)
	}
