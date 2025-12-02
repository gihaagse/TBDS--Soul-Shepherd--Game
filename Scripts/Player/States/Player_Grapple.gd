extends PlayerState
class_name Player_Grapple


@onready var ghs : GHS = get_tree().get_root().get_node("Level").find_child("GrapplingHookSystem")

func Exit():
	ghs.can_grapple = false

func Update(_delta:float):
	if not ghs.is_grappling:
		state_transition.emit(self, "Idling")
