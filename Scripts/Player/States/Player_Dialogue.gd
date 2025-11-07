extends PlayerState
class_name Player_Dialogue

func Enter():
	super()
	get_tree().set_pause(true)
	DialogueManager.dialogue_ended.connect(dilaogue_ended)

func Exit():
	get_tree().set_pause(false)

func dilaogue_ended():
	state_transition.emit(self, "Idling")
