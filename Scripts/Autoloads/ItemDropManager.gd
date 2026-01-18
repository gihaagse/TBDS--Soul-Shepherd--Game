extends Node

const tag = "item_drops"

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func drop_item(item, position: Vector2):
	if item.is_in_group(tag):
		
		var allowed = _passes_drop_roll(item)
		if not allowed:
			return
			
		var new_parent = CheckPointManager.get_root().get_node("MagicBamboo")
		print(CheckPointManager.get_root().get_node("MagicBamboo"))
		var drop_instance : MagicBamboo = item.duplicate()
		drop_instance.global_position = position
		if ("is_active" in drop_instance):
			drop_instance.is_active = true
			new_parent.call_deferred("add_child", drop_instance)
	
func _passes_drop_roll(item) -> bool:
	if not ("drop_chance" in item):
		return true
	
	var drop_chance = item.drop_chance
	
	return _random_number() <= drop_chance

func _random_number() -> int:
	return randi_range(1, 100)
