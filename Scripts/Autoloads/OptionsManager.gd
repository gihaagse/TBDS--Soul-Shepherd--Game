extends Node

func is_any_rebinding() -> bool:
	for node in get_tree().get_nodes_in_group("hotkey_button"):
		if node.can_rebind:  # Zorg dat je deze var hebt in HotkeyRebindButton
			return true
	return false
