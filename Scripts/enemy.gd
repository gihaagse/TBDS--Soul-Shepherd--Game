extends Area2D

@onready var main = get_tree().get_root().get_node("level1")
@onready var projectile = load("res://Scenes/projectile.tscn")
@export var shootPoint : Node2D
@export var can_shoot : bool = false

@onready var health: HP = $Health
@onready var label: Label = $Label
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
var old_hp : int
func _ready() -> void:
	old_hp = health.hp

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if old_hp != health.hp:
		label.text = "HP: " + str(health.hp)
		old_hp = health.hp
		audio_stream_player_2d.playing = true


func _on_health_hp_changed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(SetShader_BlinkIntensity, 1.0, 0.0, 0.5)
	
	gpu_particles_2d.restart()
	gpu_particles_2d.emitting = true

func shoot():
	var instance = projectile.instantiate()
	instance.sprite = sprite
	instance.spawnpos = shootPoint.global_position
	instance.turn_on_body.append(3)
	main.add_child.call_deferred(instance)
	
func SetShader_BlinkIntensity(newValue: float):
	sprite.material.set_shader_parameter("blink_intensity", newValue)


func _on_timer_timeout() -> void:
	if can_shoot:
		shoot()
