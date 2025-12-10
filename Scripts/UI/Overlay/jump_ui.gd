extends Node2D

@onready var jump_container = $BallMargin/JumpContainer
@onready var fsm = get_parent().get_node("FiniteStateMachine")

var full_ball  = preload("res://Assets/UI/blue_ball.png")
var empty_ball = preload("res://Assets/UI/red_ball.png")

var center_offset := Vector2(-20, -30)
var side_offset_x := 10

var current_max_jumps: int = -1

func _ready() -> void:
	set_side()
	
func _process(_delta):
	var state = fsm.current_state
	var jumps_left: int = state.jumps_left
	var max_jumps: int = state.max_double_jumps

	if max_jumps != current_max_jumps:
		current_max_jumps = max_jumps
		_build_balls(max_jumps)

	_update_textures(jumps_left)

func _build_balls(max_jumps: int) -> void:
	for child in jump_container.get_children():
		child.queue_free()

	for i in range(max_jumps):
		var ball := TextureRect.new()
		ball.texture = empty_ball
		ball.custom_minimum_size = Vector2(4.5,4.5)
		ball.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		ball.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		jump_container.add_child(ball)


func _update_textures(jumps_left: int) -> void:
	var count := jump_container.get_child_count()
	for i in range(count):
		var ball: TextureRect = jump_container.get_child(i)
		var index_from_end := count - 1 - i
		ball.texture = full_ball if index_from_end < jumps_left else empty_ball

func set_side(is_facing_right: bool = 1) -> void:
	var side := -side_offset_x if is_facing_right else side_offset_x
	position = center_offset + Vector2(side, 0)
