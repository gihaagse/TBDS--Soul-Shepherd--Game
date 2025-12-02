extends Line2D

var previous_position: Vector2 = Vector2.ZERO
var sprite_radius: float = 16.0  

@onready var player: Player = $"../.."
@onready var fsm: FSM = $"../../FiniteStateMachine"

var min_trail_speed: float = 1000
var trail_speed_initialized: bool = false

func _ready() -> void:
	var sprite_parent = get_parent() as AnimatedSprite2D
	
	if sprite_parent and sprite_parent.sprite_frames and sprite_parent.sprite_frames.has_animation(sprite_parent.animation):
		var frame_texture = sprite_parent.sprite_frames.get_frame_texture(sprite_parent.animation, sprite_parent.frame)
		if frame_texture:
			var frame_size = frame_texture.get_size() * sprite_parent.get_scale()
			sprite_radius = max(frame_size.x, frame_size.y) * 0.5  
	
	previous_position = get_parent().global_position
	

func _process(_delta: float) -> void:
	
	if not trail_speed_initialized and fsm.current_state is PlayerState:
		print("hogridaa")
		min_trail_speed = fsm.current_state.fall_speed_threshold - 5.0
		trail_speed_initialized = true
		
	if player.velocity.y < min_trail_speed:
		clear_points()
		return
		
	var current_position = get_parent().global_position
	var movement_vector = current_position - previous_position
	
	if movement_vector.length() > 0:
		var dir = -movement_vector.normalized() 
		var trail_pos = current_position + dir * sprite_radius
		add_point(to_local(trail_pos))
	
	if points.size() > 20:
		remove_point(0)
	
	previous_position = current_position
