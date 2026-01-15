extends Control

@onready var image_rect: TextureRect = $PageContainer/CurrentPage/ImageRect
@onready var text_label: RichTextLabel = $PageContainer/CurrentPage/DialogBox/VBoxContainer/RichTextLabel
@onready var page_container: Control = $PageContainer/CurrentPage
@onready var skip_button: Button = $PageContainer/CurrentPage/DialogBox/VBoxContainer/SkipButton

var pages: Array[Dictionary] = [
	{"image": preload("res://Assets/Backgrounds/aesthetic-pixel-art-of-city-japanese-shrine.jpg"), "text": "This is dummy text for the first page."},
	{"image": preload("res://Assets/Backgrounds/red-shrine-entrance.jpg"), "text": "Now, the text for the second page is displayed."},
]

var current_page_index: int = 0
var typing_tween: Tween

func _ready():
	skip_button.pressed.connect(_on_skip_pressed)
	_show_page(0)

func _show_page(index: int):
	if index >= pages.size():
		_go_to_menu()
		return
	
	current_page_index = index
	var page = pages[index]
	
	if typing_tween and typing_tween.is_running():
		typing_tween.kill()
	
	var tween = create_tween()
	tween.parallel().tween_property(image_rect, "modulate:a", 0.0, 0.3)
	await tween.finished
	
	image_rect.texture = page["image"]
	text_label.bbcode_enabled = true
	text_label.text = page["text"]
	text_label.visible_ratio = 0.0
	skip_button.text = "Skip"
	
	_start_typing()
	
	tween = create_tween()
	tween.parallel().tween_property(image_rect, "modulate:a", 1.0, 0.3)
	tween.parallel().tween_property(page_container, "modulate:a", 1.0, 0.3)

func _start_typing():
	typing_tween = create_tween()
	typing_tween.tween_property(text_label, "visible_ratio", 1.0, len(text_label.text) * 0.04)
	typing_tween.tween_callback(func(): print("Typing finished"))

func _on_skip_pressed():
	if typing_tween and typing_tween.is_running():
		if typing_tween:
			typing_tween.kill()
		text_label.visible_ratio = 1.0
		return
	
	if text_label.visible_ratio < 0.99:
		text_label.visible_ratio = 1.0
		return
	
	if current_page_index + 1 < pages.size():
		_show_page(current_page_index + 1)
	else:
		_go_to_menu()

func _go_to_menu():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.8)
	await tween.finished
	get_tree().change_scene_to_file("res://Scenes/UI/GameMenus/Start_Menu.tscn")


func _input(event):
	if event.is_action_pressed("ui_accept"):
		_on_skip_pressed()
