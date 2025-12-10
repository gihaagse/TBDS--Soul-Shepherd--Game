extends enemy

class_name boss_enemy_1

@export var jump_speed: int = -125.0
@onready var JumpTimer : Timer = $JumpTimer

func _ready() -> void:
	projectile = load("res://Scenes/Weapons/enemy_hat_projectile.tscn")
	super._ready()
	JumpTimer.start()
	speed = 0

func _process(_delta: float) -> void:
	super._process(_delta)
	if is_on_floor() and !ground.enabled:
		ground.set_enabled(true)
	if !playerInRange:
		$HatSplitTimer.stop()

func _on_jump_timer_timeout() -> void:
	if can_jump:
		jump()
	
func jump():
	velocity.y = jump_speed
	ground.set_enabled(false)

func shoot():
	print("test")
	super.shoot()
	$HatSplitTimer.start()

func _on_hat_split_timer_timeout() -> void:
	if is_instance_valid(latest_hat):
		var instance = projectile.instantiate()
		instance.sprite = sprite
		instance.spawnpos = latest_hat.global_position
		instance.spawnpos.y = instance.spawnpos.y - 10
		instance.velocity = latest_hat.velocity
		main.add_child.call_deferred(instance)
		await get_tree().process_frame
	$HatSplitTimer.stop()
