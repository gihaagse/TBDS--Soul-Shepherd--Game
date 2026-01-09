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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start(player: Player):
	_play_effects(player)
	$Sprite2D.visible = false
	$CollisionShape2D.visible = false
	set_collision_layer_value(1, false)
	await get_tree().create_timer(1).timeout
	remove()

func _play_effects(player: Player):
	$Explosion.emitting = true
	$Explosion.color = COLOR
	player.hp.health_heal(heal_amount)
	$Label.text = "+ %s hp" % heal_amount
	$Label.visible = true

func remove():
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and $CollisionShape2D.visible and is_active:
		start(body)
