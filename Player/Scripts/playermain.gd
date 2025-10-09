extends CharacterBody2D

signal player_hit
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var finite_state_machine: FSM
@export var hp : HP
@export var pause_menu : Control
var paused = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@export var velocity2D : Vector2
@onready var game_manager: Node = %GameManager
@onready var player_hitsfx: AudioStreamPlayer2D = $PlayerHit

func _process(_delta: float) -> void:
	velocity2D = velocity 
	game_manager.updateLabel(finite_state_machine.current_state.name)
	game_manager.updateHP(hp.hp)
	if Input.is_action_just_pressed("reset"):
		player_hit.emit(50)
	if hp.hp <= 0:
		collision_shape_2d.disabled = true
		game_manager.updateGameOver()

	if Input.is_action_just_pressed("Escape"):
		pauseMenu()
		
func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused
		
func SetShader_BlinkIntensity(newValue: float):
	sprite.material.set_shader_parameter("blink_intensity", newValue)


func _on_killzone_body_entered(body: Node2D) -> void:
	player_hit.emit(50)


func _on_health_hp_changed() -> void:
	if hp.hp >0:
		player_hitsfx.playing =true
	var tween = get_tree().create_tween()
	tween.tween_method(SetShader_BlinkIntensity, 1.0, 0.0, 0.5)
	
	gpu_particles_2d.restart()
	gpu_particles_2d.emitting = true
