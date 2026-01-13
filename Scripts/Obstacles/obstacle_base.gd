class_name Obstacle extends Area2D

enum EffectTypes { DAMAGE, KNOCKBACK, SLOW, SLIPPERY, BREAKING, FALLING_TILE}

@export var damage_trap: int
@export var effect_type: Array[EffectTypes]  # "damage", "knockback", "slow", "slippery"
@export var active_for: float # how long should the effect apply?
@export var is_enabled: bool = true 
# is this trap awaiting to be triggered? 
#If one time use, its only until its triggered once, 
#if multiple use it is awaiting everytime again after re-use cooldown is over

@export var is_triggered: bool = false
@export var activation_delay: float
@export var one_time_use: int
@export var reuse_cooldown: float

@onready var player_group: String = "player"
var bodies_in_area: Array[Node2D] = []
var used_bodies: Array[Node2D] = []  # Track one-time uses
var counter_used: int = 0

var original_position: Vector2
var original_sprite_modulate: Color

signal obstacle_hit(body: Node2D, effect: String)

func _ready() -> void:
	add_to_group("obstacles")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_area_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(player_group):
		bodies_in_area.append(body)
		check(body)

func _on_body_exited(body: Node2D) -> void:
	bodies_in_area.erase(body)

func _on_area_entered(area: Area2D) -> void:
	pass

# Subclasses MUST override this
func check(body: Node2D) -> void:
	assert(false, "Obstacle subclasses must implement check()")

func start(body: Node2D) -> void:
	assert(false, "Obstacle subclasses must implement apply_effect()")

func _on_trigger_ended():
	if is_triggered == false:
		for body in bodies_in_area:
			check(body)

func disable_trap():
	is_enabled = false

func _get_knockback_dir(player: Player) -> Vector2:
	return -global_transform.y.normalized()

func remove_trap():
	queue_free()
