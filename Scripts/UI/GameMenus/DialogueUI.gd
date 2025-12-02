extends CanvasLayer
class_name  DialogueScene

@onready var panel_container = $FullSize/PanelContainer
@onready var npc_name = $FullSize/PanelContainer/MarginContainer/MainContainer/ProfileIconContainer/NPCName
@onready var npc_text = $FullSize/PanelContainer/MarginContainer/MainContainer/NPCLinesAndChoicesContainer/TextBubble/NPCText
@onready var npc_icon = $FullSize/PanelContainer/MarginContainer/MainContainer/ProfileIconContainer/NPCIcon
@onready var choices_container = $FullSize/PanelContainer/MarginContainer/MainContainer/NPCLinesAndChoicesContainer/ChoicesContainer
@onready var continue_button = $FullSize/PanelContainer/ContinueButton
@onready var continue_label = $FullSize/PanelContainer/MarginContainer/MainContainer/ProfileIconContainer/ContinueLabel
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
var ending_tween = false

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
	panel_container.visible = true
	panel_container.scale = Vector2(0.3, 0.3)
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2(1, 1), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	visible = true

func hide_dialogue():
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2(0.3, 0.3), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	ending_tween = true
	tween.tween_callback(func ():
		visible = false
		DialogueManager.dialogue_completely_ended.emit()
		ending_tween = false
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
		
		var number_label: Label = button.get_node("Number")
		if number_label:
			number_label.text = str(i + 1)
			number_label.position.y += -4
		
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
	continue_label.visible = true

func hide_continue_button():
	continue_button.visible = false
	continue_label.visible = false
	
func _input(event):
	if not DialogueManager.is_dialogue_active: 
		return
	
	if ending_tween:
		return
	
	if event is InputEventKey and event.pressed and not event.is_echo():
		if event.keycode == Key.KEY_SPACE and continue_button.visible and continue_label.visible:
			_on_continue()
		elif choices_container.visible and choice_buttons.size() > 0:
			var index = -1
			match event.keycode:
				Key.KEY_1: index = 0
				Key.KEY_2: index = 1
				Key.KEY_3: index = 2
				Key.KEY_4: index = 3
				Key.KEY_5: index = 4
			if index >= 0 and index < choice_buttons.size():
				_on_choice_selected(index)
