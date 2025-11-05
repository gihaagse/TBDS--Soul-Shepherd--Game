extends CanvasLayer
class_name  DialogueScene

@onready var panel_container = $FullSize/PanelContainer
@onready var npc_name = $FullSize/PanelContainer/MarginContainer/MainContainer/ProfileIconContainer/NPCName
@onready var npc_text = $FullSize/PanelContainer/MarginContainer/MainContainer/NPCLinesAndChoicesContainer/TextBubble/NPCText
@onready var npc_icon = $FullSize/PanelContainer/MarginContainer/MainContainer/ProfileIconContainer/NPCIcon
@onready var choices_container = $FullSize/PanelContainer/MarginContainer/MainContainer/NPCLinesAndChoicesContainer/ChoicesContainer
@onready var continue_button = $FullSize/PanelContainer/ContinueButton
@onready var choice_template = $FullSize/PanelContainer/MarginContainer/MainContainer/NPCLinesAndChoicesContainer/ChoicesContainer/ChoiceTemplate

@onready var typing_sfx = $Node/Typing
@onready var continue_sfx = $Node/Continue
@onready var choice_sfx = $Node/Choice

var choice_buttons: Array[Button] = []
var is_animating_text := false
var full_line: String = ""
var current_text_index: int = 0
var text_speed: float = 0.03
var animate_text_timer: Timer = null

func _ready():
	visible = false
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	DialogueManager.text_displayed.connect(_on_text_displayed)
	DialogueManager.choices_displayed.connect(_on_choices_displayed)
	
	continue_button.pressed.connect(_on_continue)
	
	panel_container.scale = Vector2(0.3, 0.3)
	visible = false

	if not animate_text_timer:
		animate_text_timer = Timer.new()
		animate_text_timer.one_shot = false
		animate_text_timer.wait_time = text_speed
		add_child(animate_text_timer)
		animate_text_timer.timeout.connect(_on_animate_text_timer)

func _on_dialogue_started(dialogue_resource: DialogueResource):
	visible = true
	npc_icon.texture = dialogue_resource.npc_icon
	npc_name.text = dialogue_resource.name
	
	show_dialogue()

func _on_dialogue_ended():
	hide_dialogue()

func show_dialogue():
	print("SHOWING DIALOGUE")
	panel_container.visible = true
	panel_container.scale = Vector2(0.3, 0.3)
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2(1, 1), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	visible = true

func hide_dialogue():
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2(0.3, 0.3), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(func ():
		visible = false
		print("NOT SHOWING DIALOGUE")
		)

func _on_text_displayed(text: String):
	hide_choices()
	show_continue_button()
	animate_text(text)

func animate_text(line: String):
	is_animating_text = true
	full_line = line
	current_text_index = 0
	npc_text.text = ""
	animate_text_timer.wait_time = text_speed
	animate_text_timer.start()

func _on_animate_text_timer():
	if current_text_index < full_line.length():
		npc_text.text += full_line[current_text_index]
		current_text_index += 1
		typing_sfx.pitch_scale = randf_range(.3,.5)
		typing_sfx.play()
	else:
		animate_text_timer.stop()
		is_animating_text = false

func _on_choices_displayed(choices: Array[PlayerOption]):
	show_choices(choices)
	hide_continue_button()

func hide_choices():
	for button in choice_buttons:
		button.visible = false
	choice_buttons.clear()

func show_choices(choices: Array[PlayerOption]):
	hide_choices()
	for i in range(choices.size()):
		var button: Button
		button = choice_template.duplicate() as Button
		choices_container.add_child(button)
		button.text = choices[i].choice_text
		button.visible = true
		if button.pressed.is_connected(_on_choice_selected):
			button.pressed.disconnect(_on_choice_selected)
		button.pressed.connect(_on_choice_selected.bind(i))
		choice_buttons.append(button)

func _on_choice_selected(choice_index: int):
	choice_sfx.play()
	DialogueManager.choose_option(choice_index)

func _on_continue():
	continue_sfx.play()
	if is_animating_text:
		animate_text_timer.stop()
		npc_text.text = full_line
		is_animating_text = false
		continue_sfx.play()
	else:
		DialogueManager.next_line()

func show_continue_button():
	continue_button.visible = true

func hide_continue_button():
	continue_button.visible = false
