extends Area2D

@onready var main = get_tree().get_root().get_node("Level")
@onready var projectile = load("res://Scenes/projectile.tscn")
@export var shootPoint : Node2D

@onready var health: HP = $Health
@onready var label: Label = $Label
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
var old_hp : int
func _ready() -> void:
	old_hp = health.hp

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if old_hp != health.hp:
		label.text = "HP: " + str(health.hp)
		old_hp = health.hp


func _on_health_hp_changed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(SetShader_BlinkIntensity, 1.0, 0.0, 0.5)
	
	gpu_particles_2d.restart()
	gpu_particles_2d.emitting = true

func shoot():
	var instance = projectile.instantiate()
	instance.sprite = sprite
	instance.spawnpos = shootPoint.global_position
	main.add_child.call_deferred(instance)
	
func SetShader_BlinkIntensity(newValue: float):
	sprite.material.set_shader_parameter("blink_intensity", newValue)


func _on_timer_timeout() -> void:
	shoot()
