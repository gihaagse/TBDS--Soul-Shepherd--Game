extends CanvasLayer
@onready var ability_debug_menu: Control = $AbilityDebugMenu
@onready var pause_menu: Control = $PauseMenu
@onready var ability_info: Control = $Ability_info

@onready var dash_timer: Label = $DashTimer

var is_timer_on: bool = false
var dash_time: float = 1.0
var time_left: float = dash_time
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OptionsManager._set_focus_all_on_children(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		pauseMenu()
		
	if Input.is_action_just_pressed("AbilityInfo"):
		AbilityInfoMenu()
		
	if paused:
		return
		
	if Input.is_action_just_pressed("AbilityDebug"):
		ability_debug_menu.visible = !ability_debug_menu.visible
		
	if is_timer_on:
		dash_timer.visible = true
		time_left -= delta
		var seconds = int(time_left)
		var mils = int(fmod(time_left, 1) * 1000)

		var time_show = "%d.%03d" % [seconds, mils]
		dash_timer.text = time_show
		
		if time_left <= 0:
			time_left = 0
			is_timer_on = false
			dash_timer.visible = false
			time_left = dash_time
	
func start_timer() -> void:
	is_timer_on = true
	
func pauseMenu():
	if ability_info.visible:
		AbilityInfoMenu()
	
	if paused:
		pause_menu.hide()
		get_tree().set_pause(false)
	else:
		pause_menu.show()
		pause_menu.regain_menu_focus()
		#Engine.time_scale = 0
		get_tree().set_pause(true)
	
	paused = !paused
	
func AbilityInfoMenu():
	ability_info.refresh_all_indicators()
	if pause_menu.visible:
		return
		
	if paused:
		ability_info.hide()
		get_tree().set_pause(false)
	else:
		ability_info.set_focus = false
		ability_info.show()
		ability_info._update_ui() 
		ability_info.set_focus_on_first()
		#Engine.time_scale = 0
		get_tree().set_pause(true)
		
	paused = !paused
		
func _input(_event):
	if paused:
		return
