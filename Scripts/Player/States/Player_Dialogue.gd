extends PlayerState
class_name Player_Dialogue

func Enter():
	super()
	get_tree().set_pause(true)
	DialogueManager.dialogue_completely_ended.connect(_on_dilaogue_completely_ended)

func Exit():
	get_tree().set_pause(false)

func _on_dilaogue_completely_ended():
	state_transition.emit(self, "Idling")
