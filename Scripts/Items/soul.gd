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
			
			if collision_shape_2d and collision_shape_2d.shape is CapsuleShape2D:
				var new_shape = CapsuleShape2D.new()
				new_shape.radius = desired_size.x / 2.0
				new_shape.height = desired_size.y * 1.5  
				collision_shape_2d.shape = new_shape
				print("NEW - radius: ", new_shape.radius, " height: ", new_shape.height)
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
	
	if collision_shape_2d.shape is CapsuleShape2D:
		var capsule = collision_shape_2d.shape as CapsuleShape2D
		print("Radius: ", capsule.radius)
		print("Height: ", capsule.height)
	else:
		print("Geen CapsuleShape2D!")
	
