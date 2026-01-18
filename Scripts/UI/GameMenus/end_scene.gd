extends Control

@onready var image_rect: TextureRect = $PageContainer/CurrentPage/ImageRect
@onready var text_label: RichTextLabel = $PageContainer/CurrentPage/DialogBox/VBoxContainer/RichTextLabel
@onready var page_container: Control = $PageContainer/CurrentPage
@onready var skip_button: Button = $PageContainer/CurrentPage/DialogBox/VBoxContainer/SkipButton

var pages: Array[Dictionary] = [
	{"image": preload("res://Assets/Backgrounds/Endingpanel1.png"), 
	"text": "The arduous journey is over. 
	
	The Panda, The Monk, The Hero, 
	completed his task, defying death, 
	if only for a brief period.  
	
	The souls, finally completing their part in the cycle of life, 
	returned to the Tree of Life, the first to do so in decades. 
	
	Their appreciation remained for The Panda, 
	if only for moments, as they departed on to the new stage in their existence."},
	
	{"image": preload("res://Assets/Backgrounds/Endingpanel2.png"), 
	"text": "With his task complete, 
	The Hero departed alongside his love into The Tree, 
	with hopes that he could once more defy death in there, 
	remain together for as long as they could, 
	and take that next step together if they can. 
	As he took his first steps to the tree, 
	the creature he borrowed for the journey slumped back onto its feet, 
	unsure how it got there, but appreciated the view regardless."},
	
	{"image": preload("res://Assets/Backgrounds/Endingpanel3.png"), 
	"text": "With death no longer being the harbinger of doom, 
	but instead, the messenger to the next stage, 
	the lands seemingly let out a sigh of relief. 
	Though the journey past death was still unknown, 
	the knowledge of the journey itself brought a calm to all who would have to venture it one day. 
	Death was not overcome, nor defied, but instead, delayed. 
	But now, perhaps it did not have to be. 
	Perhaps now, death is where it needs to be, 
	just as our Hero is."},
]

var current_page_index: int = 0
var typing_tween: Tween
var is_last_page: bool = false

func _ready():
	skip_button.pressed.connect(_on_skip_pressed)
	_show_page(0)

func _show_page(index: int):
	if index >= pages.size():
		_go_to_menu()
		return
	
	current_page_index = index
	is_last_page = (index == pages.size() - 1)
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
	if is_last_page:
		typing_tween.tween_callback(func(): skip_button.text = "Home")

func _on_skip_pressed():
	if typing_tween and typing_tween.is_running():
		typing_tween.kill()
		text_label.visible_ratio = 1.0
		if is_last_page:
			skip_button.text = "Home"
		return
	
	if text_label.visible_ratio < 0.99:
		text_label.visible_ratio = 1.0
		if is_last_page:
			skip_button.text = "Home"
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
