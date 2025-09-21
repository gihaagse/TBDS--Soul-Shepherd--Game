extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const SPRINT_MULTIPLIER = 1.8  # Sprint snelheid is 80% sneller

const MAX_JUMPS := 2
var jumps_left := MAX_JUMPS

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jumps_left = MAX_JUMPS

	# Walljump met direction input en jumps_left
	if Input.is_action_just_pressed("jump") and is_on_wall_only() and Input.is_action_pressed("move_left"):
		velocity.y = JUMP_VELOCITY
		velocity.x = 2 * SPEED 
	
	elif Input.is_action_just_pressed("jump") and is_on_wall_only() and Input.is_action_pressed("move_right"):
		velocity.y = JUMP_VELOCITY
		velocity.x = -2 * SPEED

	elif Input.is_action_just_pressed("jump") and jumps_left > 0 and is_on_wall():
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1
		
	elif Input.is_action_just_pressed("jump") and jumps_left > 0 and not is_on_wall():
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1

	var current_speed = SPEED
	if Input.is_action_pressed("ui_shift"):  
		current_speed = SPEED * SPRINT_MULTIPLIER
	
	# Smooth movement met lerp en sprint
	var direction := float(Input.get_axis("move_left", "move_right"))
	if direction != 0.0:
		velocity.x = lerp(velocity.x, direction * current_speed, 0.1)
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.2)

	move_and_slide()
