extends CharacterBody2D
class_name Player


signal player_hit
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var finite_state_machine: FSM
@export var hp : HP

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@export var velocity2D : Vector2
@onready var game_manager: Node = %GameManager
@onready var player_hitsfx: AudioStreamPlayer2D = $PlayerHit
@onready var ray_down: RayCast2D = $Ground

func _ready() -> void:
	add_to_group("player")


func _process(delta: float) -> void:
		
	velocity2D = velocity 
	game_manager.updateLabel(finite_state_machine.current_state.name)
	game_manager.updateHP(hp.hp)
	if Input.is_action_just_pressed("reset"):
		var current_state = $FiniteStateMachine._get_current_state()
		if current_state != $FiniteStateMachine/Died:
			CheckPointManager._on_player_died(self)
	if hp.hp <= 0:
		pass
		#game_manager.updateGameOver() #Change this to reset player ui
		#collision_shape_2d.disabled = true
		

func SetShader_BlinkIntensity(newValue: float):
	sprite.material.set_shader_parameter("blink_intensity", newValue)


func _on_killzone_body_entered(body: Node2D) -> void:
	player_hit.emit(50)


func _on_health_hp_changed() -> void:
	print("damage")
	if hp.hp > 0:
		player_hitsfx.playing =true
	var tween = get_tree().create_tween()
	tween.tween_method(SetShader_BlinkIntensity, 1.0, 0.0, 0.5)
	
	gpu_particles_2d.restart()
	gpu_particles_2d.emitting = true
	

func has_ground_below() -> bool:
	if not ray_down.is_colliding():
		return false
	var collider = ray_down.get_collider()
	# Optional: check collision_layer to make sure it's actually ground
	# Assuming ground is layer 1:
	if collider is CollisionObject2D and (collider.collision_layer & (1 << 0)) != 0:
		return true
	return false
