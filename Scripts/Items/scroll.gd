extends Node2D

var custom_sprite_frames: SpriteFrames

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

@export var desired_size: Vector2 = Vector2(11,11)
@export var dialogue: ScrollDialogue


var vertical_message_offset: Vector2 = Vector2(0, 10)

func _ready() -> void:
	
	if custom_sprite_frames:
		$AnimatedSprite2D.sprite_frames = custom_sprite_frames
		
		var frame_tex = $AnimatedSprite2D.sprite_frames.get_frame_texture("default", 0)
		if frame_tex:
			var original_size = frame_tex.get_size()
			var scale_factor = Vector2(
				desired_size.x / original_size.x,
				desired_size.y / original_size.y
			)
			$AnimatedSprite2D.scale = scale_factor
			
			var shape_node = collision_shape_2d
			if shape_node and shape_node.shape:
				var shape = shape_node.shape
				if shape is CapsuleShape2D:
					shape.radius = desired_size.x / 2
					shape.height = max(0, desired_size.y - (shape.radius * 2))
	else:
		var sprite_frames = $AnimatedSprite2D.sprite_frames
		var frame_tex = sprite_frames.get_frame_texture("default", 0)
		if frame_tex:
			var original_size = frame_tex.get_size()
			var scale_factor = Vector2(
				desired_size.x / original_size.x,
				desired_size.y / original_size.y
			)
			$AnimatedSprite2D.scale = scale_factor
		else:
			push_warning("No texture")

	
	$AnimatedSprite2D.play("default")
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body is Player:
		TextboxPopupManager.start_dialogue(body.global_position + vertical_message_offset, dialogue.scroll_dialogue)
		self.queue_free()
		
