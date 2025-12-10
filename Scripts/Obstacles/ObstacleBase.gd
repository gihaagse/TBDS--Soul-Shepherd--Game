class_name Obstacle extends Area2D

@export var damage: float
@export var effect_type: String  # "damage", "knockback", "slow", "slippery"
@export var active_for: float # how long should the effect apply?
@export var is_active: bool = true
@export var is_playing: bool = false
@export var cooldown: float
@export var one_time_use: bool


@onready var player_group: String = "player"
var bodies_in_area: Array[Node2D] = []
var used_bodies: Array[Node2D] = []  # Track one-time uses

signal obstacle_hit(body: Node2D, effect: String)

func _ready() -> void:
	add_to_group("obstacles")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_area_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(player_group) and is_active:
		bodies_in_area.append(body)
		if not one_time_use or not used_bodies.has(body):
			apply_effect(body)

func _on_body_exited(body: Node2D) -> void:
	bodies_in_area.erase(body)
	if one_time_use:
		used_bodies.erase(body)

func _on_area_entered(area: Area2D) -> void:
	pass

# Subclasses MUST override this
func apply_effect(body: Node2D) -> void:
	assert(false, "Obstacle subclasses must implement apply_effect()")
