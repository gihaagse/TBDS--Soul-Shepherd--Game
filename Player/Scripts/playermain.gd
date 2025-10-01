extends CharacterBody2D

signal player_hit
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var finite_state_machine: FSM
@export var hp : HP

@export var velocity2D : Vector2
@onready var game_manager: Node = %GameManager

func _process(_delta: float) -> void:
	velocity2D = velocity 
	game_manager.updateLabel(finite_state_machine.current_state.name)
	game_manager.updateHP(hp.hp)
	if Input.is_action_just_pressed("reset"):
		player_hit.emit(50)
	if hp.hp <= 0:
		collision_shape_2d.disabled = true
		game_manager.updateGameOver()
		
