extends CanvasLayer
@onready var ability_debug_menu: Control = $AbilityDebugMenu

@onready var dash_timer: Label = $DashTimer
var is_timer_on: bool = false
var dash_time: float = 1.0
var time_left: float = dash_time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("AbilityDebug"):
		ability_debug_menu.visible = !ability_debug_menu.visible
		
	if is_timer_on:
		dash_timer.visible = true
		time_left -= delta
		var mils = fmod(time_left, 1) * 1000
		#var sec = fmod(time_left, 60)
		#var time_show = "%02d: %03d" % [sec, mils]
		var time_show = "0.%03d" % [mils]
		dash_timer.text = time_show
		
		if time_left <= 0:
			time_left = 0
			is_timer_on = false
			dash_timer.visible = false
			time_left = dash_time
	
func start_timer() -> void:
	is_timer_on = true
