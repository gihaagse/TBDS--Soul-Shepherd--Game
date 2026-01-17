extends Control
class_name CheckPointRespawnUI

@export var HoverPlane: Panel 
@onready var begin: Button = $MarginContainer/VBoxContainer/HBoxContainer/Begin
var currentHoveringButton = null
var hoverText: Label
var hoverStyleBox: StyleBoxFlat

const defaultBGAlpha = 255
const defaultShadowAlpha = 153

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CheckPointManager.player_died.connect(_on_player_died)
	OptionsManager._set_focus_all_on_children(self)
	hoverText = HoverPlane.get_node("HoverText")
	hoverStyleBox = HoverPlane.get_theme_stylebox("panel").duplicate()
	HoverPlane.add_theme_stylebox_override("panel", hoverStyleBox)
	
	HoverPlane.visible = true
	makeHoverPlaneVis()
	

func _process(delta: float) -> void:
	if currentHoveringButton:
		# Set alpha to const values
		makeHoverPlaneVis()
		
		if not hoverText: return
		
		if currentHoveringButton == "begin":
			hoverText.text = "The START option will respawn you at the start of the level!"
		elif currentHoveringButton == "closest":
			hoverText.text = "The NEAREST option will respawn you at the nearest checkpoint to where you died!"
		elif currentHoveringButton == "furthest":
			hoverText.text = "The FURTHEST option will respawn you at the furthest checkpoint that you have unlocked so far!"
	else:
		makeHoverPlaneInvis()

func makeHoverPlaneVis():
	hoverStyleBox.bg_color.a = defaultBGAlpha / 255.0
	hoverStyleBox.shadow_color.a = defaultShadowAlpha / 255.0

func makeHoverPlaneInvis():
	hoverStyleBox.bg_color.a = 0.0
	hoverStyleBox.shadow_color.a = 0.0
	hoverText.text = ""

func _on_player_died():
	if not visible:
		visible = true
		begin.grab_focus()

func _on_choice_made(perefernce_checkpoint: String):
	visible = false
	CheckPointManager.player_choice.emit(perefernce_checkpoint)

func _on_begin_pressed() -> void:
	_on_choice_made("begin")

func _on_closest_pressed() -> void:
	_on_choice_made("closest")

func _on_furthest_pressed() -> void:
	_on_choice_made("furthest")

func _on_begin_mouse_entered() -> void:
	currentHoveringButton = "begin"

func _on_begin_mouse_exited() -> void:
	currentHoveringButton = null

func _on_closest_mouse_entered() -> void:
	currentHoveringButton = "closest"

func _on_closest_mouse_exited() -> void:
	currentHoveringButton = null

func _on_furthest_mouse_entered() -> void:
	currentHoveringButton = "furthest"

func _on_furthest_mouse_exited() -> void:
	currentHoveringButton = null
