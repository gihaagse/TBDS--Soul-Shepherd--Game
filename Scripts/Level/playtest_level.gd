extends Node2D

@export var carried_abilities: AbilityUnlocking
@onready var key_1: Trigger = $Events/Key1
@onready var tile_map: TileMap = $TileMap
@onready var camera_main: CameraMain = $CameraMain
@onready var obstacle_spike_2: Area2D = $obstacle_spike2
@export var dialogue: DialogueResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var obstacles: Node2D = $Obstacles
	print(obstacles)
	CheckPointManager.register_root_obstacle(obstacles)
	add_carried_abilities()
	KeyManager.boss_death.connect(_on_boss_defeated)
	if dialogue:
		await get_tree().create_timer(1.0).timeout
		DialogueManager.start_dialogue(dialogue)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_carried_abilities():
	if not carried_abilities or carried_abilities.unlocked_abilities.is_empty():
		pass
	else:
		for ability in carried_abilities.unlocked_abilities:
			AbilityData.add_collected_ability_add_to_list(ability)
			
func _on_boss_defeated():
	key_1.position = Vector2(255, 180)
	if obstacle_spike_2:
		obstacle_spike_2.queue_free()
	tile_map.erase_cell(0, Vector2i(32,16))
	tile_map.erase_cell(0, Vector2i(32,17))
	
