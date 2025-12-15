extends PlayerState
class_name Player_Walk
@export var dash_cooldown : Timer
@onready var ghs : GHS = get_tree().get_root().get_node("Level").find_child("GrapplingHookSystem")
func Enter():
	super()
	if PlayerPro.projectile:
		sprite.play("Panda_Walk_No_Hat")
	else:
		sprite.play("Panda_Walk")
	if not PlayerPro.projectile_exists.is_connected(_update_anim):
		PlayerPro.projectile_exists.connect(_update_anim)
	ghs.can_grapple = true

func Update(_delta:float):
	if not player.is_on_floor():
		state_transition.emit(self, "Falling")
	#if Input.is_action_just_pressed("LeftClick") and get_item_by_name("Weapon", slots).visible:
	if Input.is_action_just_pressed("LeftClick"):
		state_transition.emit(self, "Attack1")
	if Input.is_action_just_pressed("Shift") and dash_cooldown.is_stopped():
		state_transition.emit(self, "Dash")
	#if Input.is_action_just_pressed("LeftClick") and get_item_by_name("Bow", slots).visible:
	if Input.is_action_just_pressed("RightClick") and not PlayerPro.projectile:
		state_transition.emit(self, "Archery")
	#if get_item_by_name("GrappleHook", slots).visible:
		#ghs.can_grapple = true
	#else: 
		#ghs.can_grapple = false
	if ghs.is_grappling:
		state_transition.emit(self, "Grapple")

func Phys_Update(_delta:float):
	movement(_delta)
	
	if Input.get_axis("Left", "Right") == 0:
		state_transition.emit(self, "Idling")
func _update_anim():
	sprite.play("Panda_Walk")
