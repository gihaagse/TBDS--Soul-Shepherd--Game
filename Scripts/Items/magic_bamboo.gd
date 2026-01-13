extends RigidBody2D
class_name MagicBamboo

@export var texture: Texture
@export var heal_amount: int
@export var COLOR: Color
@export var drop_chance: int
@export var is_active: bool = false

func _ready() -> void:
	add_to_group("item_drops")
	$Sprite2D.texture = texture
	# Remove the Label from this scene since we'll spawn it separately

func start(player: Player):
	_spawn_floating_text()
	_play_effects(player)
	$Sprite2D.visible = false
	$CollisionShape2D.visible = false
	set_collision_layer_value(1, false)
	await get_tree().create_timer(1).timeout
	remove()

func _spawn_floating_text():
	# Store reference to the label first
	var health_label = $HealthLabel
	
	# Get the screen position BEFORE reparenting
	var screen_pos = health_label.get_global_transform_with_canvas().origin
	screen_pos.y -= 30
	
	# Find the CanvasLayer in the level
	var canvas_layer = get_tree().root.find_child("CanvasLayer", false, false)
	if not canvas_layer:
		canvas_layer = get_tree().get_first_node_in_group("ui_layer")

	if canvas_layer:
		# Reparent the label to the CanvasLayer
		health_label.reparent(canvas_layer)
		
		# Now use the stored reference instead of $HealthLabel
		health_label.position = screen_pos
		health_label.text = "+ %s hp" % heal_amount
		health_label.visible = true
		
		# Animate it
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(health_label, "position:y", screen_pos.y - 50, 1.0)
		tween.tween_property(health_label, "modulate:a", 0.0, 1.0)
		tween.finished.connect(health_label.queue_free)


func _play_effects(player: Player):
	$Explosion.emitting = true
	$Explosion.color = COLOR
	player.hp.health_heal(heal_amount)

func remove():
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and $CollisionShape2D.visible and is_active:
		start(body)
