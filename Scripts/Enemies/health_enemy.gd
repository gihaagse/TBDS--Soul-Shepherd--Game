extends Node
class_name HP_Enemy
@export var hp = 50
@onready var timer: Timer = $Timer
@onready var player_death: AudioStreamPlayer2D = $PlayerDeath
var current_item : Node2D
@onready var array_items = [
	preload("res://Scenes/Items/soul.tscn")
]
@onready var array_items_scripts = [ # IMPORTANT THAT SCRIPT AND ITEMS HAVE SAME ORDER
	preload("res://Scripts/Items/soul.gd")
] 
@onready var item_spawn_point = $"../ItemSpawnPoint"
var random_number : int

signal hp_changed

func take_damage(dmg : int):
	hp -= dmg
	hp_changed.emit()
	if get_parent().is_in_group("Player") and hp <= 0:
		player_death.playing =true
		Engine.time_scale = .2
		timer.start()
	elif(hp <= 0):
		await drop_item()
		get_parent().queue_free()

func _on_player_player_hit(dmg) -> void:
	take_damage(dmg)

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

func drop_item() -> void:
	if array_items.size() == 0:
		return
	random_number = randi() % array_items.size()
	var scene: PackedScene = array_items[random_number]
	var script = array_items_scripts[random_number]
	current_item = scene.instantiate() as Node2D
	current_item.global_position = item_spawn_point.global_position
	#current_item.set_script(script)
	var container: Node = null
	if get_parent().has_node("ItemContainer"):
		container = get_parent().get_node("ItemContainer")
	elif get_tree().current_scene and get_tree().current_scene.has_node("ItemContainer"):
		container = get_tree().current_scene.get_node("ItemContainer")
	else:
		container = get_tree().current_scene if get_tree().current_scene else get_parent()

	container.call_deferred("add_child", current_item)
	print("item dropped")
