extends Node

@export var stateLabel : Label
@export var equipLabel : Label
@export var playerHud: Control
@export var gameOverScreen : ColorRect

var greenHex: String = "5ac54f"
var redHex: String = "c41b1b"

func _ready() -> void:
	print_rich("[img]res://Assets/Icons/tweakboo.png[/img]")
	get_tree().set_pause(false)

func updateLabel(text):
	if text:
		stateLabel.text = "State: " + str(text)
func updateEquip(text):
	if text:
		equipLabel.text = "Equipment: " + str(text)
		
func updateHP(hp):
	var playerHud = get_tree().current_scene.get_node_or_null("CanvasLayer/PlayerHUD")
	
	if not playerHud:
		push_error("PlayerHUD not found!")
		return
	
	var outline = playerHud.get_node("Outline")
	if not outline: 
		push_error("OUTLINE not found!")
		return
	
	var barClipped = outline.get_node("BarClipped")
	if not barClipped:
		push_error("BARCLIPPED not found!")
		return
	
	var actualBar: ProgressBar = barClipped.get_node("ActualBar")
	if not actualBar:
		push_error("ACTUAL BAR not found!")
		return
	
	var label: Label = outline.get_node("Label")
	if not label: 
		push_error("LABEL not found!")
		return
	
	print("passed all checks")
	# Calculate health percentage
	var health_percent = float(hp.hp) / float(hp.MAX_HP)
	health_percent = clamp(health_percent, 0.0, 1.0)
	var progress_value = health_percent * 100
	
	# Get the fill stylebox
	var fill_style = actualBar.get_theme_stylebox("fill") as StyleBoxFlat
	if fill_style:
		
		var target_color: Color
		if health_percent <= 0.2: 
			target_color = Color(redHex)
		else:
			target_color = Color(greenHex)
		
		var color_tween = create_tween()
		color_tween.tween_property(fill_style, "bg_color", target_color, 0.3).set_trans(Tween.TRANS_SINE)
	
	var tween = create_tween()
	tween.tween_property(actualBar, "value", progress_value, 0.2).set_trans(Tween.TRANS_BOUNCE)
	
	label.text = str(hp.hp)

func updateGameOver():
	gameOverScreen.visible = true
