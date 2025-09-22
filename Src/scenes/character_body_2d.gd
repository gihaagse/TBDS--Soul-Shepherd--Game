extends CharacterBody2D

#BASE
const BASE_WALKSPEED : float = 50.0
const BASE_RUNSPEED : float = 300.0
const BASE_JUMPPOWER : float = -250.0
const BASE_DOUBLE_JUMPPOWER : float = -250.0
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

var target_move_velocity_x: float = 0.0
var is_running_toggle : bool = false
var has_double_jump: bool = true
var can_wall_jump: bool = false

func _ready():
	add_to_group("characters")
	add_to_group("player")
	CentralManager.add_character(self)
	

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	var speed : float = BASE_RUNSPEED if is_running_toggle else BASE_WALKSPEED
	
	velocity.x = move_toward(velocity.x, target_move_velocity_x, speed * 3 * delta)
	move_and_slide()

func MOVING(direction: float):
	_update_target_velocity_x(direction)

func RUNNING():
	is_running_toggle = not is_running_toggle
	_update_target_velocity_x()

func _update_target_velocity_x(direction: float = 0.0):
	var current_direction = direction if direction != 0.0 else sign(target_move_velocity_x)
	var speed : float = BASE_RUNSPEED if is_running_toggle else BASE_WALKSPEED
	target_move_velocity_x = current_direction * speed

func JUMPING():
	if is_on_floor():
		# Normal jump
		velocity.y = BASE_JUMPPOWER
		has_double_jump = true
	elif has_double_jump and not is_on_floor():
		# Double jump
		velocity.y = BASE_JUMPPOWER * 0.8 
		has_double_jump = false
	elif is_on_wall_only() and can_wall_jump:
		# Wall jump
		velocity.y = BASE_JUMPPOWER
		velocity.x = -get_wall_normal().x * BASE_WALKSPEED 
		has_double_jump = true 
		print("Wall jump!")
	else:
		print("Can't jump!")

func IDLE():
	target_move_velocity_x = 0.0  
