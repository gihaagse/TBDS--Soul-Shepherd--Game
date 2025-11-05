@tool
extends Node2D

@export var ability_name: AbilityData.ability_list = AbilityData.ability_list.Dash
@export var custom_sprite_frames: SpriteFrames
@export var custom_sprite_scale: Vector2 = Vector2(0.225, 0.225)

@onready var ability_name_label: Label = $abilityNameLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if custom_sprite_frames:
		$AnimatedSprite2D.sprite_frames = custom_sprite_frames
		$AnimatedSprite2D.scale = custom_sprite_scale
		
		#var texture = $AnimatedSprite2D.sprite_frames.get_frame_texture("default", 0)
		#var sprite_height = texture.get_height() * $AnimatedSprite2D.scale.y
		#print("texture: ", texture)
		#print("sprite height: ", sprite_height)
		#print()
		#ability_name_label.position = Vector2(0, sprite_height + 5) 
	else:
		$AnimatedSprite2D.scale = Vector2(1,1)
	$AnimatedSprite2D.play("default")
	ability_name_label.text = AbilityData.ability_list.keys()[ability_name]
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body is Player:
		AbilityData.add_collected_ability_add_to_list(ability_name)
		self.queue_free()
