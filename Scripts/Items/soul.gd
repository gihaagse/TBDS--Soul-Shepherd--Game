extends Node2D

@export var ability: AbilityData.ability_list = AbilityData.ability_list.Airgliding
@export var custom_sprite_frames: SpriteFrames

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

@onready var ability_label: Label = $abilityNameLabel
@export var desired_size: Vector2 = Vector2(16, 16)  

var lines: Array[String]
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
		$AnimatedSprite2D.scale = Vector2(1,1)
	
	$AnimatedSprite2D.play("default")
	ability_label.text = AbilityData.ability_list.keys()[ability]
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body is Player:
		AbilityData.add_collected_ability_add_to_list(ability)
		
	lines.append("You've unlocked the %s Ability" % AbilityData.get_ability_name_from_value(ability))
	
	if ability in AbilityData.INFO.keys():
		lines.append(AbilityData.get_ability_description(ability))
		
		TextboxPopupManager.start_dialogue(body.global_position + vertical_message_offset, lines)
		self.queue_free()
		
