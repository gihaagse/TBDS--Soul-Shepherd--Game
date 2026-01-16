extends Node

@onready var text_box_scene = preload("res://Scenes/UI/Reusables/ability_box_popup.tscn")

var dialogue_lines: Array[String] = []
var current_line_index := 0

var text_box
var text_box_position: Vector2

var is_dialogue_active := false
var can_advance_line := false
var can_close := false

func start_dialogue(position: Vector2, lines: Array[String]):
	print("received lines: ", lines)
	if is_dialogue_active:
		return
	
	dialogue_lines = lines
	text_box_position = Vector2i(position)
	_show_text_box()
	
	is_dialogue_active = true
	
func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().current_scene.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialogue_lines[current_line_index])
	can_close = false
	can_advance_line = false
	
	_slowdown_game_time()

func _slowdown_game_time():
	var tween = get_tree().create_tween()
	Engine.time_scale = 0.2  
	tween.tween_property(Engine, "time_scale", 1.0, 1.0)  

	
func _on_text_box_finished_displaying(): 
	can_advance_line = true
	await get_tree().create_timer(0.2).timeout
	can_close = true
	
func _unhandled_input(event: InputEvent) -> void:
	if not (can_close and is_dialogue_active and can_advance_line):
		return
	
	if (event is InputEventKey or 
		(event is InputEventJoypadButton and event.device >= 0) or 
		(event is InputEventJoypadMotion and event.device >= 0)) and event.is_pressed():
		_advance_dialogue()

func _advance_dialogue():
	text_box.queue_free()
	current_line_index += 1
	if current_line_index >= dialogue_lines.size():
		is_dialogue_active = false
		current_line_index = 0
		return
	_show_text_box()
