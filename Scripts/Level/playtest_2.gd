extends Node2D

@export var start: Marker2D
@export var carried_abilities: AbilityUnlocking
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CheckPointManager.register_start(start)
	var obstacles: Node2D = $Obstacles
	add_carried_abilities()
	CheckPointManager.register_root_obstacle(obstacles)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_carried_abilities():
	if not carried_abilities or carried_abilities.unlocked_abilities.is_empty():
		pass
	else:
		for ability in carried_abilities.unlocked_abilities:
			AbilityData.add_collected_ability_add_to_list(ability)
